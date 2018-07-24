# IslandBlockchain
Репозиторий с конспектом и заданиями с лекций по Блокчейну на острове 1021.
Token standart:ERC721 
Для чего было реализовано это решение, для того чтобы решить задачу обмена информацией о токенах в разных блокчейн сетях.
Часто бывает так, что очень дорого делать различные простые действия над токеном в основной сети, чтобы это исправить, прибегают к болле дешевым сетям, но там очень не выгодно продавать токен.
Поэтому мы сделали так, что наш токен в основное время живет в домашней, более дешевой сеть, где пользователь может проводить с ним разлчные действия( в нашем случае изменить процент), а для продажи 
токен переносится в более дорогую сеть, где пользователю уже выгодно его продать.
Пример построен на Акциях, Акций есть владелец, процент Акций,дата покупки,колличество, стоимость покупки, стоимость сейчас.
Пользователь может посмотреть всю эту информацию в домашней(дешевой сети), так же он может вызвать функцию, которая расчитает стоимомость акций.
Но если он захочет их продать он продаст их в более выгодной сети.

Для того, чтобы запустить этот проект вам нужно проделать следующий список действий:
1.Создать или войти уже в имеющийся аккаунт в метамаск 
2.Добавить в него тестовую сеть https://sokol.poa.network ( это будет нашей домашней сетью)
3.Получить тестовые эфирки для кован и сокол http://faucet-sokol.herokuapp.com/  и https://gitter.im/kovan-testnet/faucet
4.Экспортировать приватный ключ и добавить его в файл сеттинг.по
5. В http://remix.ethereum.org загрузить DepositToken.sol в Сокол(для этого выбрать в метамаске сокол)
6. Загрузить домашний контракт тоже в Сокол(выбрать при загрузке HomeContract и указать адресс DepositToken)
7.Сделать аналогичные действия только уже в Кован при этом выбрать Внешний контракт.
8.Запустите мост.(main.py)
9.Не обновляйте страницу и не забудьте записать адресса контрактов.

-------------------------------------------------------------------------

Why this solution was implemented in order to solve the problem of exchanging information about tokens in different networked networks.
It often happens that it is very expensive to do various simple actions on the token in the main network to fix this, resort to cheap net networks, but it's not very profitable to sell a token.
Therefore, we made it so that our token in regular time lives in a home, cheaper network where the user can conduct various actions with him (in our case, change the percentage), and for sale
the token is transferred to a more expensive network, where it is already profitable for the user to sell it.
The example is built on Shares, the Shares are the owner, the percentage of Shares, the date of purchase, the quantity, the purchase price, the cost now.
The user can look at all this information in a home (cheap network), he can also call a function that calculates the cost of shares.
But if he wants to sell them, he will sell them in a more profitable network.
How to Create
In order to run this project, you need to do the following list of actions:
1.Create or log into an existing account in the metamask
2.Add the test network https://sokol.poa.network (this will be our home network)
3.To receive test ethers for the forged and falcon http://faucet-sokol.herokuapp.com/ and https://gitter.im/kovan-testnet/faucet
4. Export the private key and add it to the setting.py file.
5. In http: //remix.ethereum.org, load the DepositToken.sol into the Sokol (to do this, select the Sokol in the metamask)
6. Download the home contract, too, in the Sokol (select when downloading the Contract and specify the address of the DepositToken )
7. To do similar actions only in Kowan while choosing External contract.
8. Start the bridge. (Main.py)
9.Do not refresh the page and do not forget to write down the address of the contracts.
