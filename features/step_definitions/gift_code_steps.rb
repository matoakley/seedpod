When(/^I visit the gift code purchase page$/) do
  visit new_gift_code_path
end

When(/^I select a gifting option$/) do
  select '6 Months - £34.20', from: 'gift_code[months]'
  @months = 6
end

When(/^I enter my details as the purchaser$/) do
  @purchaser_email = Faker::Internet.email
  @purchaser_name = Faker::Name.name
  fill_in 'gift_code[purchaser_name]', with: @purchaser_name
  fill_in 'gift_code[purchaser_email]', with: @purchaser_email
end

When(/^I select to receive the code myself$/) do
  select 'I would like to receive the gift code, and give the gift myself'
  @send_to_recipient = false
end

When(/^I select to send the code directly to the recipient$/) do
  select 'I would like the gift code to be emailed directly to the recipent'
  @send_to_recipient = true
end

When(/^I enter their details as the recipient$/) do
  @recipient_email = Faker::Internet.email
  @recipient_name = Faker::Name.name
  @send_date = 2.weeks.from_now.to_date
  fill_in 'gift_code[recipient_name]', with: @recipient_name
  fill_in 'gift_code[recipient_email]', with: @recipient_email
  fill_in 'gift_code[send_date]', with: @send_date
end

Then(/^the gift code object should be created correctly in the database$/) do
  GiftCode.count.should == 1
  code = GiftCode.first
  code.code.should =~ /^[0-9a-f]{8}$/
  code.months.should == @months
  code.purchaser_name.should == @purchaser_name.to_s
  code.purchaser_email.should == @purchaser_email.to_s
  code.send_to_recipient.should == @send_to_recipient
  code.recipient_name.should == @recipient_name.to_s
  code.recipient_email.should == @recipient_email.to_s
  code.send_date.should == @send_date
end