require 'test_helper'

class RoutingWorksTest < ActionController::TestCase
  test "routes to the correct short url for the object" do
    u = User.create(:name => "foo")
    assert_recognizes({:controller => "users", :action => "show", :id => u.id}, '/foo')
  end

  test "falls through to the next rule if it doesn't match" do
    u = User.create(:name => "foo")
    g = Group.create(:name => "bar")
    assert_recognizes({:controller => "groups", :action => "show", :id => g.id}, '/bar')
  end

  test "doesn't interfere with fall through routes" do
    User.create(:name => "dummy")
    Group.create(:name => "tweedle")
    assert_routing({:path => "posts", :method => :get}, {:controller => "posts", :action => "index"})
  end
end
