system "which -s brew
if [[ $? != 0  ]] ; then
ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'
else
brew update
fi"
system "brew install phantomjs"
system "brew install chromedriver"
