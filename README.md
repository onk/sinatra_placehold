sinatra_placehold
=================

clone of [placehold.it](http://placehold.it)

`http://localhost:9292/60x80/000/f00&text=hoge`

return

![hoge.png](hoge.png)

```text
http://localhost:9292/60x80/000/f00&text=hoge
                       ^     ^   ^       ^
                       |     |   |       |
                       |     |   |        `- label (optional)
                       |     |    `- color (optional)
                       |      `- bgcolor (optional)
                        `-size (width x height) or width
```

Requirements
--------------------------------

* Ruby 1.9+
* ImageMagick

