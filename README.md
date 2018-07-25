# ERC721 Blockchain Bridge
Репозиторий с решением задачи обмена информацией о токене между двумя блокчейн сетями.

Этот пример был реализован для того, чтобы решить задачу обмена информацией о токенах в разных блокчейн сетях.
Существует проблема, что очень дорого делать различные простые действия над токеном в основной сети, чтобы это исправить, прибегают к более дешевым сетям, но там очень невыгодно продавать токен.
Поэтому мы сделали так, что наш токен в основное время живет в домашней, т.е. более дешевой сети, где пользователь может проводить с ним различные действия (в нашем случае изменить процент), а для продажи токен переносится в более дорогую сеть, где пользователю уже выгодно его продать.
Пример построен на Акциях, у Акций есть владелец, процент Акций, дата покупки, колличество, стоимость покупки, стоимость сейчас.
Пользователь может посмотреть всю эту информацию в домашней (дешевой сети), также он может вызвать функцию, которая расчитает стоимость акций.
Но если он захочет их продать, он может продать их в более выгодной сети.

# Чтобы запустить этот проект вам нужно проделать следующий список действий:

1. Создать или войти в уже имеющийся аккаунт Metamask
2. Добавить в него тестовую сеть https://sokol.poa.network (она будет нашей домашней сетью)
3. Получить тестовые эфирки для Сокол и Кован сетей http://faucet-sokol.herokuapp.com/ и https://gitter.im/kovan-testnet/faucet
4. Экспортировать приватный ключ и добавить его в файл settings.py
5. В http://remix.ethereum.org загрузить DepositToken.sol в Сокол(для этого в Metamask надо выбрать сеть Cокол)
6. Загрузить домашний контракт тоже в Сокол (выбрать при загрузке HomeContract и указать адрес DepositToken)
7. Сделать аналогичные действия только уже в Кован, при этом выбрать Внешний контракт.
8. Запустить мост (main.py)
9. Не обновлять страницу и не забыть записать адреса контрактов.

-------------------------------------------------------------------------
The repository with the solution of the task of exchanging information about the token between the two block networks.

This solution was made to solve the problem of exchanging information about tokens in different blockchains.
It often happens that it is very expensive to do various simple actions on the token in the main network. To fix this, somebody goes to cheaper blockchains, but it's not very profitable to sell a token there.
Therefore, we made that our token in regularly is in a home, cheaper network where the user can do various actions with it (in our case, change the percentage), but for sale the token should be transferred to a more expensive network, where it is already profitable for the user to sell it.
The example is built on Shares, the Shares have the owner, the percentage of Shares, the date of purchase, the quantity, the purchase price, the cost now.
The user can look at all this information in a home (cheap network), he can also call a function that calculates the cost of shares.
But if he wants to sell them, he will sell them in a more profitable network.

# To run this project, you need to do the following list of actions:
1. Create or log into an existing account in the Metamask
2. Add the test network https://sokol.poa.network (this will be our home network)
3. Receive test ethers for the Sokol and Kovan blockchains http://faucet-sokol.herokuapp.com/ and https://gitter.im/kovan-testnet/faucet
4. Export the private key and add it to the setting.py file.
5. On http://remix.ethereum.org deploy the DepositToken.sol into the Sokol (to do this, select the Sokol in the Metamask)
6. Deploy the home contract in the Sokol too (not forget to specify the address of the DepositToken)
7. Do same actions only in Kovan but using External contract.
8. Start the bridge. (main.py)
9. Do not refresh the page and do not forget to write the address of the contracts.
