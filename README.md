
<h1>Pretest</h1>

<p>
Pretest is a gem that helps you to start your automation projects. With pretest you can start and configure your environment for web and mobile automation projects with just a few commands.
</p>

<h2>Requirements</h2>

<p>
Ruby installed in your machine (we recommend ruby 32 bits version if you're using Windows, and at least Windows 7 or a newer version) and the browsers that you want to use in your web automation (except for the phantomjs, that is installed automatically if the command "pretest environment" is used).

If you're having problems with firefox, we recommend to use the version 47.0.1 (https://ftp.mozilla.org/pub/firefox/releases/) due to issues with webdriver on newer versions.
</p>

<h2>Installation</h2>

    gem install pretest

<h2>How to use</h2>

<p>
For this we have some commands that can configure your environment for tests with chromedriver / phantomjs / IEDriverServer, and then its created a new folder that can be used to store others Webdriver's that you can use for your automations projects.
We have commands to create a new project structure, and a new project scaffold with examples of steps / features / and pages already created, that you can use to start to learn and create your own projects.
</p>

<h2>Commands</h2>

<ul>
<li>pretest</li>
<li>pretest help [COMMAND]</li>
<li>pretest environment</li>
<li>pretest create project_name</li>
<li>pretest create project_name --web_scaffold</li>
</ul>

<h2>Usage</h2>

<p>
<strong>pretest:</strong> This command is used to list all the actual commands released in pretest
</p>

<p>
<strong>pretest help [COMMAND]:</strong> This command is used to list the actual command options (example: "pretest help create")
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/machado144/pretest.

## License

The code licensed here under the GNU Affero General Public License, version 3 AGPL-3.0. [GNU AGPL 3.0 License](https://github.com/machado144/pretest/blob/master/LICENSE.txt). Pretest has been developed by the VilasBoasIT team (Lucas Machado and Murilo Machado), as detailed in [VilasBoasIT Website](http://www.vilasboasit.com).
