Then(/^my subscription details should be stored$/) do
  # Check subscription ID
  User.find(@user.id).subscriptions.active.gocardless_id.should == 'ABC123'
end

Given(/^I have a subscription set up$/) do
  @subscription = @user.subscriptions.first || FactoryGirl.create(:subscription, user: @user)
  @subscription.update_attributes(gocardless_id: 'ABC123')
  @user.subscribed?.should be_true
end

Given(/^I do not have a subscription set up$/) do
  @user.subscribed?.should be_false
end

Then(/^my subscription should be marked as cancelled$/) do
  sub = Subscription.find(@subscription.id)
  sub.cancelled_at.should_not be_nil
end

Then(/^my subscription should be cancelled$/) do
  sub = double("subscription")
  sub.should_receive(:cancel!).once
  Subscription.any_instance.should_receive(:gocardless_subscription).and_return(sub)
end

Then(/^I should see a subscription warning$/) do
  page.should have_text("You don't have an active subscription right now")
end

Then(/^I should not see a subscription warning$/) do
  page.should_not have_text("You don't have an active subscription right now")
end

Then(/^my subscription should be marked as non\-organic$/) do
  @subscription ||= User.last.subscriptions.last
  @subscription.organic.should == false
end

Then(/^my subscription should be marked as organic$/) do
  @subscription ||= User.last.subscriptions.last
  @subscription.organic.should == true
end

Given(/^the subscription is organic$/) do
  @subscription.update_attributes!(organic: true)
end

Given(/^the subscription is non-organic$/) do
  @subscription.update_attributes!(organic: false)
end