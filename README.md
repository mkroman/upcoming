# Upcoming

This is a serverless function that returns a list of upcoming movies/series as
JSON.

The function should be available at https://upcoming-7fba81450628.mk.gs
providing it isn't throttled.


## Example

`curl -s https://upcoming-7fba81450628.mk.gs | jq .`

Will output:

```js
{
  "success": true,
  "videoeta": {
    "results": [
      {
        "title": "It",
        "UPC": "\"883929571482\", \"883929571499\", \"883929571994\"",
        "formats": "4K UHD, Blu-ray, DVD",
        "rating": "R",
        "box_office": "327.5",
        "dvd_release_date": "2018-01-09T00:00:00+00:00",
        "dvd_price": "10.73",
        "bluray_release_date": "2018-01-09T00:00:00+00:00",
        "bluray_price": "13.2",
        "4kud_release_date": "2018-01-09T00:00:00+00:00",
        "4kuhd_price": "30.73",
        "theatrical_release": "2017-09-08",
        "item_price": null,
        "game_release_date": null,
        "actors": "Bill Skarsgard, Finn Wolfhard, Nicholas Hamilton, Jaeden Lieberher"
      },
      {
        "title": "Blade Runner 2049",
        "UPC": "\"883929571857\", \"883929571888\", \"888574587239\", \"883929571864\"",
        "formats": "4K UHD, Blu-ray, DVD",
        "rating": "R",
        "box_office": "92.0",
        "dvd_release_date": "2018-01-16T00:00:00+00:00",
        "dvd_price": "10.73",
        "bluray_release_date": "2018-01-16T00:00:00+00:00",
        "bluray_price": "13.2",
        "4kud_release_date": "2018-01-16T00:00:00+00:00",
        "4kuhd_price": "30.73",
        "theatrical_release": "2017-10-06",
        "item_price": null,
        "game_release_date": null,
        "actors": "Ryan Gosling, Harrison Ford, Ana de Armas, Sylvia Hoeks"
      },
      // …
    ],
    "updated_at": "2018-09-07T04:16:54+00:00",
    "wall_time": 12.412373629
  },
  "updated_at": "2018-09-07T04:16:54+00:00"
}
```

## Response format

The response format is currently not very consistent and will probably change
in the future to be more source agnostic.

The release dates are returned in ISO 8601 format and they are guessed based
on the server time since there's no official documentation on what timezone
they're stored in, from the sources.

## License

This is licensed under the MIT license.
