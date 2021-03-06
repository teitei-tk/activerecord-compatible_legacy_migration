describe ActiveRecord::CompatibleLegacyMigration do
  describe "db:migrate" do
    before do
      create_db
    end

    after do
      drop_db
    end

    it { expect { up_migrate }.not_to output(/DEPRECATION WARNING: Directly inheriting from ActiveRecord::Migration is deprecated/).to_stderr }
  end

  describe "#migration_class" do
    subject { ActiveRecord::CompatibleLegacyMigration.migration_class }

    context "when ActiveRecord.version < 5.0.0", if: ActiveRecord.version < Gem::Version.new("5.0.0") do
      it { should eq ActiveRecord::Migration }
    end

    context "when 5.0.0 <= ActiveRecord.version", if: Gem::Version.new("5.0.0") <= ActiveRecord.version do
      [4.2, 5.0].each do |version|
        context "when config.default_version is #{version}" do
          before do
            ActiveRecord::CompatibleLegacyMigration.config.default_version = version
          end

          it { should eq ActiveRecord::Migration[version] }
        end
      end
    end
  end
end
