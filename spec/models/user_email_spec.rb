require "rails_helper"

RSpec.describe User, type: :model do
  describe "email validations" do
    subject { create(:user) } # for uniqueness validation tests

    context "presence validation" do
      it "is invalid when email is blank" do
        user = build(:user, email: "")
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("is invalid")
      end

      it "is valid when email is present" do
        user = build(:user, email: "valid@example.com")
        expect(user).to be_valid
      end
    end

    context "format validation" do
      it "is invalid for incorrect formats" do
        invalid_emails = [
          "plainaddress",
          "missingatsign.com",
          "missingdomain@.com",
          "missingusername@domain",
          "user@domain,com"
        ]

        invalid_emails.each do |invalid_email|
          user = build(:user, email: invalid_email)
          expect(user).not_to be_valid, "Expected #{invalid_email} to be invalid"
          expect(user.errors[:email]).to include("is invalid")
        end
      end

      it "is valid for correct email format" do
        valid_emails = [
          "test@example.com",
          "user.name+tag@example.co.uk",
          "first.last@domain.io"
        ]

        valid_emails.each do |valid_email|
          user = build(:user, email: valid_email)
          expect(user).to be_valid, "Expected #{valid_email} to be valid"
        end
      end
    end

    context "uniqueness validation" do
      it "does not allow duplicate emails regardless of case" do
        create(:user, email: "Duplicate@Example.com")
        duplicate_user = build(:user, email: "duplicate@example.com")

        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).to include("has already been taken")
      end
    end

    context "normalization behavior" do
      it "normalizes email to lowercase and strips whitespace before validation" do
        user = create(:user, email: "  TestUser@Example.COM  ")
        expect(user.email).to eq("testuser@example.com")
      end
    end
  end

  describe "generated email_domain column" do
    let!(:user) { create(:user, email: "test.user@example.com") }

    context "on creation" do
      it "automatically sets email_domain based on the email" do
        expect(user.email_domain).to eq("example.com")
      end
    end

    context "on update" do
      before do
        user.update!(email: "updated@newdomain.org")
      end

      it "updates email_domain when the email changes" do
        expect(user.email_domain).to eq("newdomain.org")
      end
    end

    context "edge cases" do
      it "handles uppercase emails correctly by normalizing domain" do
        user.update!(email: "MIXEDCASE@DOMAIN.COM")
        expect(user.email_domain).to eq("domain.com")
      end

      it "handles subdomains correctly" do
        user.update!(email: "person@mail.sub.example.co.uk")
        expect(user.email_domain).to eq("mail.sub.example.co.uk")
      end
    end

    context "database index" do
      it "enforces uniqueness at the database level (case-insensitive)" do
        create(:user, email: "unique@example.com")
        expect {
          User.create!(email: "Unique@Example.com")
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
