require "rails_helper"

RSpec.describe User, type: :model do
  describe "email validations" do
    it "validates presence, basic format, and case-insensitive uniqueness" do
      pending "Add email column, normalization, and DB uniqueness; write model validations"
    end
  end

  describe "generated email_domain column" do
    it "derives email_domain from email and updates when email changes" do
      pending "Add STORED generated column and index; ensure it stays in sync"
    end
  end
end
