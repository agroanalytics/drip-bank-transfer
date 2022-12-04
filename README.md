# README

## Drip Challange
by Renan Kataoka

### Running locally with Docker
1. Build project

```sh
docker-compose build
```

3. Create & seed database with example data

```sh
docker-compose run web bundle exec rake db:create db:migrate db:seed
```

3. Run project

```sh
docker-compose up
```

4. Test

There is a Postman collection (Drip.postman_collection.json) in this project so you can use it as an example to test the App. Note that you'll have to use the UUIDs for the accounts that were generated on your environment

You can take a look at the available data by running:

```sh
docker-compose run web bundle exec rake data:show
```

### Running automated tests

```sh
docker-compose run web bundle exec rspec
```

### Testing remotely
You can use the seeded users for testing on the remote environment provided below:

<img width="1144" alt="image" src="https://user-images.githubusercontent.com/34048664/205466193-3d2677e7-8de9-41c2-ac2f-9a2256a446d8.png">

Request example:
```sh
curl --location --request POST 'https://powerful-reef-70806.herokuapp.com/api/v1/transfer-money' \
--header 'Content-Type: application/json' \
--data-raw '{
    "account_from_id": "2c417271-dd4c-457e-8999-62e517f8c7a5",
    "account_to_id": "5961e855-e08e-45af-a973-05130a960a69",
    "amount": 40
}'
```

### Folder Structure

The folder structure below contains all files that were created and are important for this project.

```
app/
├─ boundaries/
│  ├─ use_case/
│  │  ├─ bank_transfer/
│  │  │  ├─ transfer_money.rb
controllers/
├─ api/
│  ├─ v1/
│  │  ├─ transfer_money_controller.rb
domain/
├─ dtos/
│  ├─ credit_operation.rb
│  ├─ transfer.rb
├─ entities/
│  ├─ bank.rb
│  ├─ account.rb
│  ├─ customer.rb
├─ repositories/
│  ├─ accounts_repository.rb
├─ services/
│  ├─ money_transfer_service.rb
│  ├─ strategies/
│  │  ├─ same_bank_strategy.rb
│  │  ├─ different_bank_strategy.rb
│  │  ├─ credit_calculator.rb
│  │  ├─ base_transfer_strategy.rb
│  │  ├─ constraints/
│  │  │  ├─ system_failure.rb
│  │  │  ├─ transfer_amount_valid.rb
│  │  │  ├─ artificial_random_failure.rb
│  │  │  ├─ invalid_amount.rb
│  │  ├─ operations/
│  │  │  ├─ deduct_fixed_amount_from_sender_operation.rb
│  │  ├─ steps/
│  │  │  ├─ invalid_wallet_operation.rb
│  │  │  ├─ perform_account_transfer.rb
│  │  │  ├─ validate_constraints.rb
│  │  │  ├─ validate_wallet_operation.rb
db/
├─ migrate/
│  ├─ 20221203054043_enable_uuid.rb
│  ├─ 20221203054621_create_banks.rb
│  ├─ 20221203054737_create_customers.rb
│  ├─ 20221203055037_create_accounts.rb
├─ schema.rb
├─ seeds.rb
spec/
├─ <All tests are here...>
```
