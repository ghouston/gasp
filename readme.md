[GASP](http://www.gaspgroup.org/) scripts
=======================================

License:
--------
The MIT License (MIT)

Copyright (c) 2013 Gregory N. Houston

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Description:
------------
Scripts to support GASP's research into toxic chemicals around the county.

extract_ids.rb
--------------

reads a csv file and finds all the property ids (e.g. 18 digit numbers)

`ruby extract_ids.rb data/marchresults.csv`

scrape_addresses.rb
-------------------

reads a csv file of property ids (created by `extract_ids`) and outputs the `property_id, owner, property_location` in csv format

`cat data/marchresults.csv | ruby extract_ids.rb | ruby scrape_addresses.rb`
