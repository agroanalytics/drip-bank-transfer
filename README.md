# README

## Drip Challange
by Renan Kataoka
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
