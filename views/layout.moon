import Widget from require "lapis.html"

cache_buster = require "helpers.cache_buster"

class Layout extends Widget
  @include "widgets.helpers"

  content: =>
    html_5 ->
      head ->
        meta charset: "utf-8"
        title ->
          if @title
            text "#{@title} - LuaRocks"
          else
            text "LuaRocks - The Lua package manager"

        if @canonical_url
          link rel: "canonical", href: @canonical_url

        link href: "https://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700", rel: "stylesheet", type: "text/css"
        link href: "/static/icons/style.css", rel: "stylesheet", type: "text/css"

        if @page_description
          meta name: "description", content: @page_description

        link rel: "stylesheet", href: "/static/style.css?#{cache_buster}"

        raw [[
          <script type="text/javascript">
            if (window.location.hostname != "localhost") {
              var _gaq = _gaq || [];
              _gaq.push(['_setAccount', 'UA-136625-8']);
              _gaq.push(['_trackPageview']);

              (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
              })();
            }
          </script>
        ]]


      body ->
        div class: "content", ->
          div class: "header", ->
            div class: "header_inner", ->
              @user_panel!
              a href: @url_for"index", ->
                if @current_user
                  img class: "icon_logo", alt: "LuaRocks", src: "/static/header_luarocks_icon.svg"
                else
                  img class: "text_logo", alt: "LuaRocks", src: "/static/header_luarocks_name.svg"

              form class: "header_search", action: @url_for("search"), method: "GET", ->
                input type: "text", name: "q", placeholder: "Search modules or uploaders...", value: @params.q

          @content_for "inner"

        div class: "footer", ->
          div class: "right", ->
            a href: "http://twitter.com/luarocksorg", "@luarocksorg"
            raw " &middot; "
            revision = require "revision"
            a href: "https://github.com/leafo/luarocks-site/commit/#{revision}", rel: "nofollow", revision
            raw " &middot; "
            a href: "http://github.com/leafo/luarocks-site", "Source"
            raw " &middot; "
            a href: "https://github.com/leafo/luarocks-site/issues", "Issues"

          a href: @url_for("index"), "Home"
          raw " &middot; "
          a href: @url_for"search", "Search"
          raw " &middot; "
          a href: @url_for("manifest", manifest: "root"), "Root Manifest"
          raw " &middot; "
          a href: @url_for"manifests", "Manifests"
          raw " &middot; "
          a href: @url_for"modules", "Modules"
          raw " &middot; "
          a href: @url_for"changes", "Changes"
          raw " &middot; "
          a href: @url_for"about", "About"

        div class: "sub_footer", ->
          a href: "https://github.com/mashape/kong", ->
            img width: "117", height: "47", alt: "Sponsored by Kong", src: "/static/kong.svg"

      @content_for "js_init"

  user_panel: =>
    div class: "user_panel", ->
      if @current_user and @current_user\get_unseen_notifications_count! > 0
        a href: @url_for("notifications"), title: "notifications", class: "unread_notifications",
          @current_user\get_unseen_notifications_count!

      a href: "https://github.com/luarocks/luarocks/wiki/Download", "Install"
      raw " &middot; "
      a href: "https://github.com/luarocks/luarocks/wiki/Documentation", "Docs"
      raw " &middot; "

      if @current_user
        a href: @url_for("user_profile", user: @current_user), class: "login", -> b @current_user.username
        raw " &middot; "
        a href: @url_for"upload_rockspec", "Upload"
        raw " &middot; "
        a href: @url_for"user_settings.profile", "Settings"
        raw " &middot; "
        a href: @url_for"user_logout", "Log Out"
      else
        login_params = { return_to: @params.return_to, intent: @params.intent }
        a href: @url_for("user_login", nil, login_params), "Log In"
        raw " &middot; "
        a href: @url_for("user_register", nil, login_params), "Register"


