// All of these should be similar to js as well (except ds list, as js doesn't use ds lists and
// array_reduce as that's a lot of work to make that spec-compliant).

#region array scripts
	/*
		These js prototypes will not be added, as they promote bad/lazy habits:
		at, copyWithin, of
	*/
	function array_add(_array) { // js equivalent to:  new Set(_array)
		/// @description array_push, but removes duplicate entries.
		for (var i = 1; i < argument_count; i++) {
			array_push(_array, argument[i]);
		}
		_array = array_remove_duplicates(_array);
		return _array;
	}
	
	function array_concat(_arrays) {
		/// @description Concatenates numbers and arrays into new array.
		var _arr = [];
		for (var i = 0; i < argument_count; i++) {
			if (typeof(argument[i]) != "array") array_push(_arr, argument[i]);
			if (typeof(argument[i]) == "array") {
				for (var j = 0; j < array_length(argument[i]); j++) {
					array_push(_arr, argument[i][j]);
				}
			}
		}
		return _arr;
	}
	
	function array_entries(_array) constructor { // GM is limited in mimicking this implementation.
		array = _array;
		index = 0;
		next = function() {
			index++;
			return {
				value: _array[index]
			}
		}
	}
	
	/*
		array_every([3, 5, 6, 100, 9], function(_num) {
			return _num > 2;
		}); // returns true
	*/
	function array_every(_array, _callback) {
		var _counter = 0;
		var _len = array_length(_array);
		for (var i = 0; i < _len; i++) {
			if (_callback(_array[i])) _counter++;
		}
		return (_counter == _len);
	}
	
	function array_fill(_array, _fillItem, _start=0, _end=array_length(_array)) {
		for (var i = 0; i < _end; i++) {
			if (i >= _start && i <= _end) _array[@ i] = _fillItem;
		}
		return _array;
	}
	
	function array_filter(_array, _callback) {
		var _arr = [];
		for (var i = 0; i < array_length(_array); i++) {
			if (_callback(_array[i])) array_push(_arr, _array[i]);
		}
		return _arr;
	}
	
	/*
		array_find example:
		array_find(["a", "b", "c", "d", "e"], function(arg) {
			return arg == "c";
		}); // returns "c"
		
		array_find([{a: "one", b: "two"}, {a: 1, b: 2}, {a: "alpha", b: "beta"}], function(arg) {
			return arg.b == "beta";
		}); // returns {a: "alpha", b: "beta"}
	*/
	function array_find(_array, _callback) {
		for (var i = 0; i < array_length(_array); i++) {
			if (_callback(_array[i])) return _array[i];
		}
	}
	
	function array_findIndex(_array, _callback) {
		for (var i = 0; i < array_length(_array); i++) {
			if (_callback(_array[@ i])) return i;
		}
		return -1;
	}
	
	function array_flat(_array, flatDepth=0) { // array_flat not fully tested. Use with caution.
		var _flatDepth = is_nan(argument[1]) ? 1 : real(argument[1]);
		var _arr = [];
		array_copy(_arr, 0, _array, 0, array_length(_array));
		
		return (_flatDepth ? array_reduce(_array, function(_acc, _cur) {
			if (is_array(_cur)) {
				array_push(_acc, array_flat(_array, _flatDepth - 1));
			} else {
				array_push(_acc, _cur);
			}
		}, []) : _arr);
	}
	
	function array_for_each(_array, _callback) {
		for (var i = 0; i < array_length(_array); i++) {
			_callback(_array[i], i, _array);
		}
	}
	
	function array_from(_input, _optionalCallback) {
		var _arr = [];
		if (_optionalCallback) {
			for (var i = 0; i <= array_length(_input); i++) {
				_input[@ i] = _optionalCallback(_input[@ i]);
			}
		}
		switch (typeof(_input)) {
			case "array":
				return _input;
				break;
			case "string":
				for (var i = 1; i <= string_length(_input); i++) {
					array_push(_arr, string_char_at(_input, i));
				}
				return _arr;
				break;
		}
		return _arr;
	}
	
	function array_includes(_array, item) {
		for (var i = 0; i < array_length(_array); i++) {
			if (_array[i] == item) return true;
		}
		return false;
	}
	
	function array_index_of(_array, _item) {
		for (var i = 0; i < array_length(_array); i++) {
			if (_array[@ i] == _item) return i;
		}
		return false;
	}
	
	function array_join(_array, _term="") {
		var _str = "";
		for (var i = 0; i < array_length(_array); i++) {
			_str += _array[@ i] + _term;
		}
		return _str;
	}
	
	function array_keys(_array) constructor { // GM is limited in mimicking this implementation.
		array = _array;
		index = 0;
		keys = function() {
			index++;
			return _array[@ index];
		}
	}
	
	function array_last_index_of(_array, _term) {
		for (var i = array_length(_array)-1; i >= 0; i--) {
			if (_array[@ i] == _term) return i;
		}
		return -1;
	}
	
	function array_map(_array, _callback) {
		var _arr = [];
		for (var i = 0; i < array_length(_array); i++) {
			array_push(_arr, _callback(_array[i]));
		}
		return _arr;
	}
	
	function array_pop(_array) {
		/// @description Removes last element in array, and returns it.
		var _len = array_length(_array);
		var _elem = _array[@ _len-1];
		array_copy(_array, 0, _array, 0, _len-2);
		return _elem;
	}
	
	function array_reduce(_array, _callback, _initialValue=0) {
		var _accumulator = _initialValue;
		
		for (var i = 0; i < array_length(_array); i++) {
			_accumulator = _callback(_accumulator, _array[i]);
		}
		
		return _accumulator;
	}
	
	function array_remove(_array, _item) {
		/// @description array_add, but finds, then removes item.
		var _arr = [];
		for (var i = 0; i < (argument_count - 1); i++) {
			if (i == _item) continue;
			array_push(_arr, _item);
		}
		_array = _arr;
		return _array;
	}
	
	function array_remove_duplicates(_array) {
		var _arr = [];
		for (var i = 0; i < array_length(_array); i++) {
			// If element doesn't exist in new array.
			if (!array_index_of(_arr, _array[i])) array_push(_arr, _array[i]);
		}
		return _arr;
	}
	
	function array_reverse(_array) {
		var _arr = [];
		for (var i = array_length(_array); i >= 0; i--) {
			array_push(_arr, _array[i]);
		}
		_array = _arr;
		return _arr;
	}
	
	function array_shift(_array) {
		/// @description Removes 1st element in array, and returns it.
		var _elem = _array[0];
		// copies all items after 1st item into new array.
		array_copy(_array, 0, _array, 1, array_length(_array));
		return _elem;
	}
	
	function array_some(_array, _callback) {
		for (var i = 0; i < array_length(_array); i++) {
			if (_callback(_array[i])) return true;
		}
		return false;
	}
	
	function array_splice(_array, _ind1, _ind2, _optionalValues) {
		/// @description Remove or replace element(s). Modifies original array.
		/// @param {_array} array
		var _arr = [], _passed = false;
		_ind2 += _ind1;
		for (var i = 0; i < array_length(_array); i++) {
			if (i >= _ind1 && i <= _ind2) {
				for (var j = 3; j < argument_count; j++) {
					array_push(_arr, argument[j]);
				}
				i = _ind2;
			}
			array_push(_arr, _array[@ i]);
		}
		_array = _arr;
		return _array;
	}
	
	function array_unshift(_array, _items) {
		var _arr = [];
		
		for (var i = 1; i < argument_count; i++) {
			array_push(_arr, argument[i]);
		}
		_array = array_concat(_arr, _array);
		return array_length(_array);
	}
	
	
	
	function ds_list_to_array(_dsList) {
		var _arr = [];
		for (var i = 0; i < ds_list_size(_dsList); i++) {
			array_push(_arr, ds_list_find_value(_dsList, i));
		}
		return _arr;
	}
	
	
	
	function struct_to_array(_struct) {
		//var _arr = array_create(1, []);
		var _arr = [];
		var _keys = variable_struct_get_names(_struct);
		for (var i = 0; i < array_length(_keys); i++) {
			array_push(_arr, [_keys[i], _struct[$ _keys[i]]]);
		}
		
		return _arr;
	}
#endregion
