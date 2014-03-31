# Tomaten - A Helper for doing Daily Pomomdoro on the terminal

This is a helper for working with Pomodoro. I use this for my everyday work.

## Tools

### thyme
Thyme is a rubygem and a simple pomodoro timer.

    gem install thyme

**~/thymerc:**

    option :b, :break, 'start a break' do
      set :timer, 5*60
      run
    end
    option :c, :bigbreak, 'start a bigbreak' do
      set :timer, 15*60
      run
    end
    after do |seconds_left|
      `notify-send -u critical -i /usr/share/icons/gnome/32x32/status/dialog-warning.png "Thymes Up!"` if seconds_left == 0
    end

### tmux

If you use TMUX as terminal multiplexer you can add a pomodoro status to your
tmux status-line

**~/thymerc:**

    ...
    set tmux, true
    ...

**~/.tmux.conf**

    ...
    set-option -g status-right '#(cat ~/.thyme-tmux)'
    set-option -g status-interval 1
    ...

### tmux powerline

If you use tmux powerline you can add a new segment

**~/.tmux-powerline/segments/thyme.sh**

    # Prints the thyme
    #
    # Ensure your thyme-tmux-theme is set to:
    # set :tmux_theme, "%s %s"

    run_segment() {
      if [ -f /home/${USER}/.thyme-tmux ]; then
        echo -n "Pomodoro: "
        CURRENT_TIME=$(cat ~/.thyme-tmux | awk '{print $2}')
        CURRENT_CONV=$(date -d "1970-01-01 ${CURRENT_TIME}" +"%s")
        if [ $CURRENT_CONV -le 14400 ]; then
          echo "#[fg=red]$CURRENT_TIME#[fg=default]"
        else
          echo $CURRENT_TIME
        fi
      else
        return 1
      fi
      return 0
    }

In your tmux-powerline theme

**~/tmux-powerline/themes/mytheme.sh**

    ...
    if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
      TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
      #"earthquake 3 0" \
      # "pwd 89 211" \
      "thyme 233 136" \
    ...

### Pandoc

Pandoc is used to generate a HTML Version of the Daily-Pomodoro Files.

## Aliases (bash, zsh, etc)

Example alias with this repo under ~/pomodoro
```
alias dailypomo='vi ~/pomodoro/pomodori/$(date +"%F").markdown -c "source ~/pomodoro/lib/vim-template"'
```

## Template

The Alias loads a markdown template for planing your pomodori.

## Dailypomodoro Legend

* **I** Whole Pomodori use for this
* **i** Some time of this pomodori used
* **x** disturbed while pomodoring

### Example

An example day:

    # Planned 2014-03-14

    * Fix bug 1337 in project gotham 1-3 # I think this bug will need 1-3 pomodori
    * Write puppet module for fantasy 3-4

    ---

    # Reality

    * Fix Bug 1337 in project gotham II #Two full pomodori
    * Cleaned kitchen Ii #One full pomodori and one partial
    * Fix Bug 1338 in project gotham Ix #One Fill pomodori and one with disturbance

## Markdown to HTML

To convert the markdown to HTML I use ```pandoc```.

    pandoc --self-contained -o /tmp/file.html REAMDE.md -c ./css/pandoc.css -c ./css/github2.css

To convert your daily pomodoris to HTML you can use following commands:

```
bash generate-html.sh
google-chrome ./html/index.html
```

##TODO:
* Mac OS X compatibility

---

vim: ft=markdown
