#!/usr/bin/ruby

require 'pathname'

Pathname.new('.').children.select{|dir| (dir / '.git').exist? }.each do|dir|
	Dir.chdir dir do
		if `git remote --verbose` =~ /idanarye/
			branches = `git branch`.lines.grep(/\b(develop|master)\b/){$1}
			branch = branches.sort.first
		else
			branch = 'master'
		end
		cmd = "git checkout #{branch}"
		system cmd
	end
end
