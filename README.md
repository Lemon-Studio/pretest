
<h1>Pretest</h1>

<h2>Installation</h2>

    gem install pretest

<p>
Pretest is a gem to help you to start your automation project. With pretest you can start and configure your environment for web and mobile automation projects with just a few commands.
</p>

<h2>And how do i do this?</h2>

<p>
It's easy, the unique requirement is the Ruby installed in your machine (we recommend ruby 32 bits version if you're using windows, and at least Windows 7 or a newer version) and the browsers that you want to use in your web automation (except for the phantomjs, that is installed automatically if the command "pretest environment" is used).
If you're having problems with firefox, we recommend to use the version 47.0.1 (https://ftp.mozilla.org/pub/firefox/releases/) due to issues with webdriver on newer versions.
</p>

<h2>And how do i do this?</h2>

<p>
It's simple, for this we have some commands that can configure your environment for tests with chromedriver/phantomjs/IEDriverServer, and then its created a new folder that can be used to store others webdriver that you can use for your automations projects.
We have commands to create a new project structure, and a new project scaffold with examples of steps/features/and pages already created, that you can use to start to learn and create your own projects.
</p>

<h3>Commands</h3>

<ul>
<li>pretest help</li>
<li>pretest environment</li>
<li>pretest create project_name</li>
<li>pretest create project_name --web_scaffold</li>
<li>pretest create project_name --ios<strong>(Soon)</strong></li>
<li>pretest create project_name --android<strong>(Soon)</strong></li>
<li>pretest create project_name --ios_scaffold<strong>(Soon)</strong></li>
<li>pretest create project_name --android_scaffold<strong>(Soon)</strong></li>
</ul>

<h3>Usage</h3>

<p>
<strong>pretest help:</strong> This command is used to list all the actual commands released in pretest
</p>

<p>
<strong>pretest environment:</strong> This command is used to configure your environment variables, download the webdrivers that can be use in your projects and install a development tool to compile your code (just if needed).
</p>

<p>
<strong>pretest create project_name:</strong> This command is used to create a new project for web automation with all the structure already created and environment configured.
</p>

<p>
<strong>pretest create project_name --web_scaffold:</strong> This command is used to create a new project for web automation with all the structure already created and environment configured, including some steps, features and pages with examples that can be used to develop new tests cases.
</p>

<strong>pretest create project_name --ios (not released yet!)</strong> This command is used to create a new project for ios-calabash automation with all the structure already created and environment configured.
</p>

<p>
<strong>pretest create project_name --android (not released yet!)</strong> This command is used to create a new project for android-calabash automation with all the structure already created and environment configured.
</p>

<p>
<strong>pretest create project_name --ios_scaffold:</strong> This command is used to create a new project for ios-calabash automation with all the structure already created and environment configured, including some steps, features and pages with examples that can be used to develop new tests cases.
</p>

<p>
<strong>pretest create project_name --android_scaffold:</strong> This command is used to create a new project for android-calabash automation with all the structure already created and environment configured, including some steps, features and pages with examples that can be used to develop new tests cases.
</p>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/machado144/pretest.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

