import time
from multiprocessing import Process

from web3 import Web3, HTTPProvider

from settings import abi_bridge, sokol, kovan, private_key, from_address, to_address


class Wb:
    def __init__(self, abi, pk, url_from, url_to, from_address, to_address):
        self.lastProcessedBlock = 0
        self.W3from = Web3(HTTPProvider(url_from))
        self.W3to = Web3(HTTPProvider(url_to))
        self.acct = self.W3from.eth.account.privateKeyToAccount(pk)
        self.abi = abi
        self.from_address = Web3.toChecksumAddress(from_address)
        self.to_address = Web3.toChecksumAddress(to_address)
        self.from_bridge = self.W3from.eth.contract(abi=self.abi, address=self.from_address)
        self.to_bridge = self.W3to.eth.contract(abi=self.abi, address=self.to_address)

    def get_logs(self):
        filter_home = {
            "fromBlock": self.lastProcessedBlock,
            "toBlock": "latest",
            "address": self.from_address
        }
        logs = self.W3from.eth.getLogs(filter_home)
        print(logs, [], sep="")
        return logs

    # list_events.append([ev.args['_owner']['_tokenID']['_serializedData']])
    def send_transaction(self, data):
        # print(data)
        for i in data:
            # print(i)
            receipt = self.W3from.eth.getTransactionReceipt(i['transactionHash'])
            events = self.from_bridge.events.UserRequestForSignature().processReceipt(receipt)
            for ev in events:
                nonce = self.W3to.eth.getTransactionCount(self.acct.address)
                tx_foreign = {
                    "gas": 7000000,
                    "gasPrice": Web3.toWei(1, "gwei"),
                    "nonce": nonce
                }
                tx = self.to_bridge.functions.transferApproved(
                    ev.args['_from'],
                    ev.args['_tokenVIN'],
                    ev.args['_data'],
                    ev.transactionHash
                ).buildTransaction(tx_foreign)
                signed_tx = self.acct.signTransaction(tx)
                tx_hash = self.W3to.eth.sendRawTransaction(signed_tx.rawTransaction)
                self.W3to.eth.waitForTransactionReceipt(tx_hash)
                print(tx_hash.hex())
            self.lastProcessedBlock = receipt.blockNumber + 1
        time.sleep(5)

    def start_monitor(self):
        while True:
            data = self.get_logs()
            self.send_transaction(data)


if __name__ == "__main__":
    Home = Wb(abi_bridge, private_key, sokol, kovan,
              from_address, to_address)
    Foreign = Wb(abi_bridge, private_key, kovan, sokol,
                 from_address, to_address)
    home_proccess = Process(target=Home.start_monitor())
    home_proccess.start()
    foreign_proccess = Process(target=Foreign.start_monitor())
    foreign_proccess.start()
