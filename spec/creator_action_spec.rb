describe Fastlane::Actions::CreatorAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The creator plugin is working!")

      Fastlane::Actions::CreatorAction.run(nil)
    end
  end
end
