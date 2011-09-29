# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{taf2-curb}
  s.version = "0.2.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ross Bamford", "Todd A. Fisher"]
  s.date = %q{2009-03-13}
  s.description = %q{Curb (probably CUrl-RuBy or something) provides Ruby-language bindings for the libcurl(3), a fully-featured client-side URL transfer library. cURL and libcurl live at http://curl.haxx.se/}
  s.email = %q{todd.fisher@gmail.com}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["LICENSE", "README"]
  s.files = ["LICENSE", "README", "Rakefile", "doc.rb", "ext/extconf.rb", "lib/curb.rb", "lib/curl.rb", "ext/curb.c", "ext/curb_postfield.c", "ext/curb_multi.c", "ext/curb_errors.c", "ext/curb_easy.c", "ext/curb_easy.h", "ext/curb_errors.h", "ext/curb_macros.h", "ext/curb.h", "ext/curb_postfield.h", "ext/curb_config.h", "ext/curb_multi.h", "tests/tc_curl_multi.rb", "tests/tc_curl_postfield.rb", "tests/bug_curb_easy_blocks_ruby_threads.rb", "tests/unittests.rb", "tests/bug_require_last_or_segfault.rb", "tests/bug_instance_post_differs_from_class_post.rb", "tests/tc_curl_download.rb", "tests/alltests.rb", "tests/helper.rb", "tests/tc_curl_easy.rb", "tests/require_last_or_segfault_script.rb"]
  s.homepage = %q{http://curb.rubyforge.org/}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{curb}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Ruby libcurl bindings}
  s.test_files = ["tests/tc_curl_multi.rb", "tests/tc_curl_postfield.rb", "tests/bug_curb_easy_blocks_ruby_threads.rb", "tests/unittests.rb", "tests/bug_require_last_or_segfault.rb", "tests/bug_instance_post_differs_from_class_post.rb", "tests/tc_curl_download.rb", "tests/alltests.rb", "tests/helper.rb", "tests/tc_curl_easy.rb", "tests/require_last_or_segfault_script.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
