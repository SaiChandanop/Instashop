// page init
jQuery(function(){
	jcf.customForms.replaceAll();
	initCarousel();
	initInputs();
	initValidation();
	initRegButton();
});

function initRegButton() {
	jQuery('.switch-btn').click(function(e) {
		var link = jQuery(this);
		var num = link.attr('href').substring(1);
		jQuery('.slideshow').data('ScrollGallery').numSlide(num-1);
	});
}

//init registration form
function initValidation() {
	var errorClass = 'error';
	var successClass = 'success';
	var regEmail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	var regPhone = /^[0-9]+$/;

	jQuery('.slide:has(form, .sign-holder)').each(function(){
		var holder = jQuery(this);
		var form = holder.find('form');
		var successBlock = holder.find('.sign-holder')
		var successFlag = true;
		var inputs = form.find('input:text, select');

		// form validation function
		function validateForm() {
			successFlag = true;
			
			inputs.each(checkField);
			return successFlag;
		}
		
		// check field
		function checkField(i, obj) {
			var currentObject = $(obj);
			var currentParent = currentObject.parents('.row, .validate-row');
			
			// not empty fields
			if(currentObject.hasClass('required-text')) {
				setState(currentParent, currentObject, !currentObject.val().length || currentObject.val() === currentObject.prop('defaultValue'));
			}
			// correct email fields
			if(currentObject.hasClass('required-email')) {
				setState(currentParent, currentObject, !regEmail.test(currentObject.val()));
			}
			// correct number fields
			if(currentObject.hasClass('required-number')) {
				setState(currentParent, currentObject, !regPhone.test(currentObject.val()));
			}
			// correct number fields
			if(currentObject.hasClass('optional-number')) {
				if(!currentObject.val().length || currentObject.val() === currentObject.prop('defaultValue')) return;
				setState(currentParent, currentObject, !regPhone.test(currentObject.val()));
			}
			// something selected
			if(currentObject.hasClass('required-select')) {
				setState(currentParent, currentObject, currentObject.get(0).selectedIndex === 0);
			}
		}
		
		// set state
		function setState(hold, field, error) {
			hold.removeClass(errorClass).removeClass(successClass);
			if(error) {
				hold.addClass(errorClass);
				field.one('focus',function(){hold.removeClass(errorClass).removeClass(successClass);});
				successFlag = false;
			} else {
				hold.addClass(successClass);
			}
		}

		function sendData() {
			jQuery.ajax({
				type: form.attr('method'),
				url: form.attr('action'),
				data: form.serialize(),
				success: function() {
					form.slideUp();
					successBlock.slideDown();
				},
				error: function(){
					alert('AJAX Error!');
				}
			});
		}
		
		// form event handlers
		form.find(':submit').click(function(e) {
			if(validateForm()) sendData();
			e.preventDefault();
		});
	});
}

// scroll gallery init
function initCarousel() {
	jQuery('.carousel').scrollGallery({
		mask: '.mask',
		slider: '.slideset-inner',
		slides: '.slide-inner',
		btnPrev: '.btn-prev',
		btnNext: '.btn-next',
		generatePagination: '.pagination-inner',
		autoRotation: true,
		switchTime: 3000,
		animSpeed: 500
	});
	jQuery('.slideshow').scrollGallery({
		mask: '.smask',
		slides: '.slide',
		btnPrev: '.btn-prev',
		btnNext: '.btn-next',
		autoRotation: false,
		switchTime: 3000,
		animSpeed: 500,
		circularRotation: false,
		stretchSlideToMask: true
	});
}

// clear inputs on focus
function initInputs() {
	PlaceholderInput.replaceByOptions({
		// filter options
		clearInputs: true,
		clearTextareas: true,
		clearPasswords: true,
		skipClass: 'default',
		
		// input options
		wrapWithElement: false,
		showUntilTyping: false,
		getParentByClass: false,
		placeholderAttr: 'value'
	});
}

/*
 * jQuery Carousel plugin
 */
;(function($){
	function ScrollGallery(options) {
		this.options = $.extend({
			mask: 'div.mask',
			slider: '>*',
			slides: '>*',
			activeClass:'active',
			disabledClass:'disabled',
			btnPrev: 'a.btn-prev',
			btnNext: 'a.btn-next',
			generatePagination: false,
			pagerList: '<ul>',
			pagerListItem: '<li><a href="#"></a></li>',
			pagerListItemText: 'a',
			pagerLinks: '.pagination li',
			currentNumber: 'span.current-num',
			totalNumber: 'span.total-num',
			btnPlay: '.btn-play',
			btnPause: '.btn-pause',
			btnPlayPause: '.btn-play-pause',
			galleryReadyClass: 'gallery-js-ready',
			autorotationActiveClass: 'autorotation-active',
			autorotationDisabledClass: 'autorotation-disabled',
			stretchSlideToMask: false,
			circularRotation: true,
			disableWhileAnimating: false,
			autoRotation: false,
			pauseOnHover: isTouchDevice ? false : true,
			maskAutoSize: false,
			switchTime: 4000,
			animSpeed: 600,
			event:'click',
			swipeGap: false,
			swipeThreshold: 15,
			handleTouch: true,
			vertical: false,
			useTranslate3D: false,
			step: false
		}, options);
		this.init();
	}
	ScrollGallery.prototype = {
		init: function() {
			if(this.options.holder) {
				this.findElements();
				this.attachEvents();
				this.refreshPosition();
				this.refreshState(true);
				this.resumeRotation();
				this.makeCallback('onInit', this);
			}
		},
		findElements: function() {
			// define dimensions proporties
			this.fullSizeFunction = this.options.vertical ? 'outerHeight' : 'outerWidth';
			this.innerSizeFunction = this.options.vertical ? 'height' : 'width';
			this.slideSizeFunction = 'outerHeight';
			this.maskSizeProperty = 'height';
			this.animProperty = this.options.vertical ? 'marginTop' : 'marginLeft';
			this.swipeProperties = this.options.vertical ? ['up', 'down'] : ['left', 'right'];

			// control elements
			this.gallery = $(this.options.holder).addClass(this.options.galleryReadyClass);
			this.mask = this.gallery.find(this.options.mask);
			this.slider = this.mask.find(this.options.slider);
			this.slides = this.slider.find(this.options.slides);
			this.btnPrev = this.gallery.find(this.options.btnPrev);
			this.btnNext = this.gallery.find(this.options.btnNext);
			this.currentStep = 0; this.stepsCount = 0;

			// get start index
			if(this.options.step === false) {
				var activeSlide = this.slides.filter('.'+this.options.activeClass);
				if(activeSlide.length) {
					this.currentStep = this.slides.index(activeSlide);
				}
			}

			// calculate offsets
			this.calculateOffsets();

			// create gallery pagination
			if(typeof this.options.generatePagination === 'string') {
				this.pagerLinks = $();
				this.buildPagination();
			} else {
				this.pagerLinks = this.gallery.find(this.options.pagerLinks);
				this.attachPaginationEvents();
			}

			// autorotation control buttons
			this.btnPlay = this.gallery.find(this.options.btnPlay);
			this.btnPause = this.gallery.find(this.options.btnPause);
			this.btnPlayPause = this.gallery.find(this.options.btnPlayPause);

			// misc elements
			this.curNum = this.gallery.find(this.options.currentNumber);
			this.allNum = this.gallery.find(this.options.totalNumber);
		},
		attachEvents: function() {
			// bind handlers scope
			var self = this;
			this.bindHandlers(['onWindowResize']);
			$(window).bind('load resize orientationchange', this.onWindowResize);

			// previous and next button handlers
			if(this.btnPrev.length) {
				this.prevSlideHandler = function(e) {
					e.preventDefault();
					self.prevSlide();
				};
				this.btnPrev.bind(this.options.event, this.prevSlideHandler);
			}
			if(this.btnNext.length) {
				this.nextSlideHandler = function(e) {
					e.preventDefault();
					self.nextSlide();
				};
				this.btnNext.bind(this.options.event, this.nextSlideHandler);
			}

			// pause on hover handling
			if(this.options.pauseOnHover && !isTouchDevice) {
				this.hoverHandler = function() {
					if(self.options.autoRotation) {
						self.galleryHover = true;
						self.pauseRotation();
					}
				};
				this.leaveHandler = function() {
					if(self.options.autoRotation) {
						self.galleryHover = false;
						self.resumeRotation();
					}
				};
				this.gallery.bind({mouseenter: this.hoverHandler, mouseleave: this.leaveHandler});
			}

			// autorotation buttons handler
			if(this.btnPlay.length) {
				this.btnPlayHandler = function(e) {
					e.preventDefault();
					self.startRotation();
				};
				this.btnPlay.bind(this.options.event, this.btnPlayHandler);
			}
			if(this.btnPause.length) {
				this.btnPauseHandler = function(e) {
					e.preventDefault();
					self.stopRotation();
				};
				this.btnPause.bind(this.options.event, this.btnPauseHandler);
			}
			if(this.btnPlayPause.length) {
				this.btnPlayPauseHandler = function(e) {
					e.preventDefault();
					if(!self.gallery.hasClass(self.options.autorotationActiveClass)) {
						self.startRotation();
					} else {
						self.stopRotation();
					}
				};
				this.btnPlayPause.bind(this.options.event, this.btnPlayPauseHandler);
			}

			// swipe event handling
			if(isTouchDevice) {
				// enable hardware acceleration
				if(this.options.useTranslate3D) {
					this.slider.css({'-webkit-transform': 'translate3d(0px, 0px, 0px)'});
				}
				
				// swipe gestures
				if(this.options.handleTouch && jQuery.fn.hammer) {
					this.mask.hammer({
						drag_block_horizontal: this.options.vertical ? false : true,
						drag_block_vertical: this.options.vertical ? true : false,
						drag_min_distance: 1
					}).on(this.options.vertical ? 'touch release dragup dragdown swipeup swipedown' : 'touch release dragleft dragright swipeleft swiperight', function(ev){
						switch(ev.type) {
							case 'touch': 
								if(!self.galleryAnimating){
									self.originalOffset = parseInt(self.slider.stop(true, false).css(self.animProperty), 10);
								}
								break;
							case (self.options.vertical? 'dragup' : 'dragright'):
							case (self.options.vertical? 'dragdown' : 'dragleft'):
								if(!self.galleryAnimating){
									if(ev.gesture.direction === self.swipeProperties[0] || ev.gesture.direction === self.swipeProperties[1]){
										var tmpOffset = self.originalOffset + ev.gesture[self.options.vertical ? 'deltaY' : 'deltaX'];
										tmpOffset = Math.max(Math.min(0, tmpOffset), self.maxOffset)
										self.tmpProps = {};
										self.tmpProps[self.animProperty] = tmpOffset;
										self.slider.css(self.tmpProps);
										ev.gesture.preventDefault();
									};
								};
								break;
							case (self.options.vertical ? 'swipeup' : 'swipeleft'):
								if(!self.galleryAnimating){
									if(ev.gesture.direction === self.swipeProperties[0]) self.nextSlide();
								}
								ev.gesture.stopDetect();
								break;
							case (self.options.vertical ? 'swipedown' : 'swiperight'):
								if(!self.galleryAnimating){
									if(ev.gesture.direction === self.swipeProperties[1]) self.prevSlide();
								}
								ev.gesture.stopDetect();
								break;

							case 'release':
								if(!self.galleryAnimating){
									if(Math.abs(ev.gesture[self.options.vertical ? 'deltaY' : 'deltaX']) > self.options.swipeThreshold) {
										if(self.options.vertical){
											if(ev.gesture.direction == 'down') self.prevSlide(); else if(ev.gesture.direction == 'up') self.nextSlide();
										}
										else {
											if(ev.gesture.direction == 'right') self.prevSlide(); else if(ev.gesture.direction == 'left') self.nextSlide();
										}
									}
									else {
										self.switchSlide();
									}
								}
								break;
						}
					});
				}
			}
		},
		onWindowResize: function() {
			if(!this.galleryAnimating) {
				this.calculateOffsets();
				this.refreshPosition();
				this.buildPagination();
				this.refreshState();
				this.resizeQueue = false;
			} else {
				this.resizeQueue = true;
			}
		},
		refreshPosition: function() {
			this.currentStep = Math.min(this.currentStep, this.stepsCount - 1);
			this.tmpProps = {};
			this.tmpProps[this.animProperty] = this.getStepOffset();
			this.slider.stop().css(this.tmpProps);
		},
		calculateOffsets: function() {
			var self = this, tmpOffset, tmpStep;
			if(this.options.stretchSlideToMask) {
				var tmpObj = {};
				tmpObj[this.innerSizeFunction] = this.mask[this.innerSizeFunction]();
				this.slides.css(tmpObj);
			}

			this.maskSize = this.mask[this.innerSizeFunction]();
			this.sumSize = this.getSumSize();
			this.maxOffset = this.maskSize - this.sumSize;

			// vertical gallery with single size step custom behavior
			if(this.options.vertical && this.options.maskAutoSize) {
				this.options.step = 1;
				this.stepsCount = this.slides.length;
				this.stepOffsets = [0];
				tmpOffset = 0;
				for(var i = 0; i < this.slides.length; i++) {
					tmpOffset -= $(this.slides[i])[this.fullSizeFunction](true);
					this.stepOffsets.push(tmpOffset);
				}
				this.maxOffset = tmpOffset;
				return;
			}

			// scroll by slide size
			if(typeof this.options.step === 'number' && this.options.step > 0) {
				this.slideDimensions = [];
				this.slides.each($.proxy(function(ind, obj){
					self.slideDimensions.push( $(obj)[self.fullSizeFunction](true) );
				},this));

				// calculate steps count
				this.stepOffsets = [0];
				this.stepsCount = 1;
				tmpOffset = tmpStep = 0;
				while(tmpOffset > this.maxOffset) {
					tmpOffset -= this.getSlideSize(tmpStep, tmpStep + this.options.step);
					tmpStep += this.options.step;
					this.stepOffsets.push(Math.max(tmpOffset, this.maxOffset));
					this.stepsCount++;
				}
			}
			// scroll by mask size
			else {
				// define step size
				this.stepSize = this.maskSize;

				// calculate steps count
				this.stepsCount = 1;
				tmpOffset = 0;
				while(tmpOffset > this.maxOffset) {
					tmpOffset -= this.stepSize;
					this.stepsCount++;
				}
			}
		},
		getSumSize: function() {
			var sum = 0;
			this.slides.each($.proxy(function(ind, obj){
				sum += $(obj)[this.fullSizeFunction](true);
			},this));
			this.slider.css(this.innerSizeFunction, sum);
			return sum;
		},
		getStepOffset: function(step) {
			step = step || this.currentStep;
			if(typeof this.options.step === 'number') {
				return this.stepOffsets[this.currentStep];
			} else {
				return Math.max(-this.currentStep * this.stepSize, this.maxOffset);
			}
		},
		getSlideSize: function(i1, i2) {
			var sum = 0;
			for(var i = i1; i < Math.min(i2, this.slideDimensions.length); i++) {
				sum += this.slideDimensions[i];
			}
			return sum;
		},
		buildPagination: function() {
			if(typeof this.options.generatePagination === 'string') {
				if(!this.pagerHolder) {
					this.pagerHolder = this.gallery.find(this.options.generatePagination);
				}
				if(this.pagerHolder.length && this.oldStepsCount != this.stepsCount) {
					this.oldStepsCount = this.stepsCount;
					this.pagerHolder.empty();
					this.pagerList = $(this.options.pagerList).appendTo(this.pagerHolder);
					for(var i = 0; i < this.stepsCount; i++) {
						$(this.options.pagerListItem).appendTo(this.pagerList).find(this.options.pagerListItemText).text(i+1);
					}
					this.pagerLinks = this.pagerList.children();
					this.attachPaginationEvents();
				}
			}
		},
		attachPaginationEvents: function() {
			var self = this;
			this.pagerLinksHandler = function(e) {
				e.preventDefault();
				self.numSlide(self.pagerLinks.index(e.currentTarget));
			};
			this.pagerLinks.bind(this.options.event, this.pagerLinksHandler);
		},
		prevSlide: function() {
			if(!(this.options.disableWhileAnimating && this.galleryAnimating)) {
				if(this.currentStep > 0) {
					this.currentStep--;
					this.switchSlide();
				} else if(this.options.circularRotation) {
					this.currentStep = this.stepsCount - 1;
					this.switchSlide();
				}
			}
		},
		nextSlide: function(fromAutoRotation) {
			if(!(this.options.disableWhileAnimating && this.galleryAnimating)) {
				if(this.currentStep < this.stepsCount - 1) {
					this.currentStep++;
					this.switchSlide();
				} else if(this.options.circularRotation || fromAutoRotation === true) {
					this.currentStep = 0;
					this.switchSlide();
				}
			}
		},
		numSlide: function(c) {
			if(this.currentStep != c) {
				this.currentStep = c;
				this.switchSlide();
			}
		},
		switchSlide: function() {
			var self = this;
			this.galleryAnimating = true;
			this.tmpProps = {};
			this.tmpProps[this.animProperty] = this.getStepOffset();
			this.slider.stop().animate(this.tmpProps, {duration: this.options.animSpeed, complete: function(){
				// animation complete
				self.galleryAnimating = false;
				if(self.resizeQueue) {
					self.onWindowResize();
				}

				// onchange callback
				self.makeCallback('onChange', self);
				self.autoRotate();
			}});
			this.refreshState();

			// onchange callback
			this.makeCallback('onBeforeChange', this);
		},
		refreshState: function(initial) {
			if(this.options.step === 1 || this.stepsCount === this.slides.length) {
				this.slides.removeClass(this.options.activeClass).eq(this.currentStep).addClass(this.options.activeClass);
			}
			this.pagerLinks.removeClass(this.options.activeClass).eq(this.currentStep).addClass(this.options.activeClass);
			this.curNum.html(this.currentStep+1);
			this.allNum.html(this.stepsCount);

			// initial refresh
			if(this.options.maskAutoSize && typeof this.options.step === 'number') {
				this.tmpProps = {};
				this.tmpProps[this.maskSizeProperty] = this.slides.eq(Math.min(this.currentStep,this.slides.length-1))[this.slideSizeFunction](true);
				this.mask.stop()[initial ? 'css' : 'animate'](this.tmpProps);
			}

			// disabled state
			if(!this.options.circularRotation) {
				this.btnPrev.add(this.btnNext).removeClass(this.options.disabledClass);
				if(this.currentStep === 0) this.btnPrev.addClass(this.options.disabledClass);
				if(this.currentStep === this.stepsCount - 1) this.btnNext.addClass(this.options.disabledClass);
			}
		},
		startRotation: function() {
			this.options.autoRotation = true;
			this.galleryHover = false;
			this.autoRotationStopped = false;
			this.resumeRotation();
		},
		stopRotation: function() {
			this.galleryHover = true;
			this.autoRotationStopped = true;
			this.pauseRotation();
		},
		pauseRotation: function() {
			this.gallery.addClass(this.options.autorotationDisabledClass);
			this.gallery.removeClass(this.options.autorotationActiveClass);
			clearTimeout(this.timer);
		},
		resumeRotation: function() {
			if(!this.autoRotationStopped) {
				this.gallery.addClass(this.options.autorotationActiveClass);
				this.gallery.removeClass(this.options.autorotationDisabledClass);
				this.autoRotate();
			}
		},
		autoRotate: function() {
			var self = this;
			clearTimeout(this.timer);
			if(this.options.autoRotation && !this.galleryHover && !this.autoRotationStopped) {
				this.timer = setTimeout(function(){
					self.nextSlide(true);
				}, this.options.switchTime);
			} else {
				this.pauseRotation();
			}
		},
		bindHandlers: function(handlersList) {
			var self = this;
			$.each(handlersList, function(index, handler) {
				var origHandler = self[handler];
				self[handler] = function() {
					return origHandler.apply(self, arguments);
				};
			});
		},
		makeCallback: function(name) {
			if(typeof this.options[name] === 'function') {
				var args = Array.prototype.slice.call(arguments);
				args.shift();
				this.options[name].apply(this, args);
			}
		},
		destroy: function() {
			// destroy handler
			$(window).unbind('load resize orientationchange', this.onWindowResize);
			this.btnPrev.unbind(this.options.event, this.prevSlideHandler);
			this.btnNext.unbind(this.options.event, this.nextSlideHandler);
			this.pagerLinks.unbind(this.options.event, this.pagerLinksHandler);
			this.gallery.unbind({mouseenter: this.hoverHandler, mouseleave: this.leaveHandler});

			// autorotation buttons handlers
			this.stopRotation();
			this.btnPlay.unbind(this.options.event, this.btnPlayHandler);
			this.btnPause.unbind(this.options.event, this.btnPauseHandler);
			this.btnPlayPause.unbind(this.options.event, this.btnPlayPauseHandler);

			// destroy swipe handler
			if(this.options.handleTouch && $.fn.hammer) {
				this.mask.hammer().off('touch release dragup dragdown dragleft dragright swipeup swipedown swipeleft swiperight');
			}

			// remove inline styles, classes and pagination
			var unneededClasses = [this.options.galleryReadyClass, this.options.autorotationActiveClass, this.options.autorotationDisabledClass];
			this.gallery.removeClass(unneededClasses.join(' '));
			this.slider.add(this.slides).removeAttr('style');
			if(typeof this.options.generatePagination === 'string') {
				this.pagerHolder.empty();
			}
		}
	};

	// detect device type
	var isTouchDevice = /MSIE 10.*Touch/.test(navigator.userAgent) || ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch;

	// jquery plugin
	$.fn.scrollGallery = function(opt){
		return this.each(function(){
			$(this).data('ScrollGallery', new ScrollGallery($.extend(opt,{holder:this})));
		});
	};
}(jQuery));

/*
 * JavaScript Custom Forms Module
 */
jcf = {
	// global options
	modules: {},
	plugins: {},
	baseOptions: {
		unselectableClass:'jcf-unselectable',
		labelActiveClass:'jcf-label-active',
		labelDisabledClass:'jcf-label-disabled',
		classPrefix: 'jcf-class-',
		hiddenClass:'jcf-hidden',
		focusClass:'jcf-focus',
		wrapperTag: 'div'
	},
	// replacer function
	customForms: {
		setOptions: function(obj) {
			for(var p in obj) {
				if(obj.hasOwnProperty(p) && typeof obj[p] === 'object') {
					jcf.lib.extend(jcf.modules[p].prototype.defaultOptions, obj[p]);
				}
			}
		},
		replaceAll: function(context) {
			for(var k in jcf.modules) {
				var els = jcf.lib.queryBySelector(jcf.modules[k].prototype.selector, context);
				for(var i = 0; i<els.length; i++) {
					if(els[i].jcf) {
						// refresh form element state
						els[i].jcf.refreshState();
					} else {
						// replace form element
						if(!jcf.lib.hasClass(els[i], 'default') && jcf.modules[k].prototype.checkElement(els[i])) {
							new jcf.modules[k]({
								replaces:els[i]
							});
						}
					}
				}
			}
		},
		refreshAll: function(context) {
			for(var k in jcf.modules) {
				var els = jcf.lib.queryBySelector(jcf.modules[k].prototype.selector, context);
				for(var i = 0; i<els.length; i++) {
					if(els[i].jcf) {
						// refresh form element state
						els[i].jcf.refreshState();
					}
				}
			}
		},
		refreshElement: function(obj) {
			if(obj && obj.jcf) {
				obj.jcf.refreshState();
			}
		},
		destroyAll: function() {
			for(var k in jcf.modules) {
				var els = jcf.lib.queryBySelector(jcf.modules[k].prototype.selector);
				for(var i = 0; i<els.length; i++) {
					if(els[i].jcf) {
						els[i].jcf.destroy();
					}
				}
			}
		}
	},
	// detect device type
	isTouchDevice: ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch,
	isWinPhoneDevice: navigator.msPointerEnabled && /MSIE 10.*Touch/.test(navigator.userAgent),
	// define base module
	setBaseModule: function(obj) {
		jcf.customControl = function(opt){
			this.options = jcf.lib.extend({}, jcf.baseOptions, this.defaultOptions, opt);
			this.init();
		};
		for(var p in obj) {
			jcf.customControl.prototype[p] = obj[p];
		}
	},
	// add module to jcf.modules
	addModule: function(obj) {
		if(obj.name){
			// create new module proto class
			jcf.modules[obj.name] = function(){
				jcf.modules[obj.name].superclass.constructor.apply(this, arguments);
			}
			jcf.lib.inherit(jcf.modules[obj.name], jcf.customControl);
			for(var p in obj) {
				jcf.modules[obj.name].prototype[p] = obj[p]
			}
			// on create module
			jcf.modules[obj.name].prototype.onCreateModule();
			// make callback for exciting modules
			for(var mod in jcf.modules) {
				if(jcf.modules[mod] != jcf.modules[obj.name]) {
					jcf.modules[mod].prototype.onModuleAdded(jcf.modules[obj.name]);
				}
			}
		}
	},
	// add plugin to jcf.plugins
	addPlugin: function(obj) {
		if(obj && obj.name) {
			jcf.plugins[obj.name] = function() {
				this.init.apply(this, arguments);
			}
			for(var p in obj) {
				jcf.plugins[obj.name].prototype[p] = obj[p];
			}
		}
	},
	// miscellaneous init
	init: function(){
		if(navigator.msPointerEnabled) {
			this.eventPress = 'MSPointerDown';
			this.eventMove = 'MSPointerMove';
			this.eventRelease = 'MSPointerUp';
		} else {
			this.eventPress = this.isTouchDevice ? 'touchstart' : 'mousedown';
			this.eventMove = this.isTouchDevice ? 'touchmove' : 'mousemove';
			this.eventRelease = this.isTouchDevice ? 'touchend' : 'mouseup';
		}

		setTimeout(function(){
			jcf.lib.domReady(function(){
				jcf.initStyles();
			});
		},1);
		return this;
	},
	initStyles: function() {
		// create <style> element and rules
		var head = document.getElementsByTagName('head')[0],
			style = document.createElement('style'),
			rules = document.createTextNode('.'+jcf.baseOptions.unselectableClass+'{'+
				'-moz-user-select:none;'+
				'-webkit-tap-highlight-color:rgba(255,255,255,0);'+
				'-webkit-user-select:none;'+
				'user-select:none;'+
			'}');

		// append style element
		style.type = 'text/css';
		if(style.styleSheet) {
			style.styleSheet.cssText = rules.nodeValue;
		} else {
			style.appendChild(rules);
		}
		head.appendChild(style);
	}
}.init();

/*
 * Custom Form Control prototype
 */
jcf.setBaseModule({
	init: function(){
		if(this.options.replaces) {
			this.realElement = this.options.replaces;
			this.realElement.jcf = this;
			this.replaceObject();
		}
	},
	defaultOptions: {
		// default module options (will be merged with base options)
	},
	checkElement: function(el){
		return true; // additional check for correct form element
	},
	replaceObject: function(){
		this.createWrapper();
		this.attachEvents();
		this.fixStyles();
		this.setupWrapper();
	},
	createWrapper: function(){
		this.fakeElement = jcf.lib.createElement(this.options.wrapperTag);
		this.labelFor = jcf.lib.getLabelFor(this.realElement);
		jcf.lib.disableTextSelection(this.fakeElement);
		jcf.lib.addClass(this.fakeElement, jcf.lib.getAllClasses(this.realElement.className, this.options.classPrefix));
		jcf.lib.addClass(this.realElement, jcf.baseOptions.hiddenClass);
	},
	attachEvents: function(){
		jcf.lib.event.add(this.realElement, 'focus', this.onFocusHandler, this);
		jcf.lib.event.add(this.realElement, 'blur', this.onBlurHandler, this);
		jcf.lib.event.add(this.fakeElement, 'click', this.onFakeClick, this);
		jcf.lib.event.add(this.fakeElement, jcf.eventPress, this.onFakePressed, this);
		jcf.lib.event.add(this.fakeElement, jcf.eventRelease, this.onFakeReleased, this);

		if(this.labelFor) {
			this.labelFor.jcf = this;
			jcf.lib.event.add(this.labelFor, 'click', this.onFakeClick, this);
			jcf.lib.event.add(this.labelFor, jcf.eventPress, this.onFakePressed, this);
			jcf.lib.event.add(this.labelFor, jcf.eventRelease, this.onFakeReleased, this);
		}
	},
	fixStyles: function() {
		// hide mobile webkit tap effect
		if(jcf.isTouchDevice) {
			var tapStyle = 'rgba(255,255,255,0)';
			this.realElement.style.webkitTapHighlightColor = tapStyle;
			this.fakeElement.style.webkitTapHighlightColor = tapStyle;
			if(this.labelFor) {
				this.labelFor.style.webkitTapHighlightColor = tapStyle;
			}
		}
	},
	setupWrapper: function(){
		// implement in subclass
	},
	refreshState: function(){
		// implement in subclass
	},
	destroy: function() {
		if(this.fakeElement && this.fakeElement.parentNode) {
			this.fakeElement.parentNode.removeChild(this.fakeElement);
		}
		jcf.lib.removeClass(this.realElement, jcf.baseOptions.hiddenClass);
		this.realElement.jcf = null;
	},
	onFocus: function(){
		// emulated focus event
		jcf.lib.addClass(this.fakeElement,this.options.focusClass);
	},
	onBlur: function(cb){
		// emulated blur event
		jcf.lib.removeClass(this.fakeElement,this.options.focusClass);
	},
	onFocusHandler: function() {
		// handle focus loses
		if(this.focused) return;
		this.focused = true;

		// handle touch devices also
		if(jcf.isTouchDevice) {
			if(jcf.focusedInstance && jcf.focusedInstance.realElement != this.realElement) {
				jcf.focusedInstance.onBlur();
				jcf.focusedInstance.realElement.blur();
			}
			jcf.focusedInstance = this;
		}
		this.onFocus.apply(this, arguments);
	},
	onBlurHandler: function() {
		// handle focus loses
		if(!this.pressedFlag) {
			this.focused = false;
			this.onBlur.apply(this, arguments);
		}
	},
	onFakeClick: function(){
		if(jcf.isTouchDevice) {
			this.onFocus();
		} else if(!this.realElement.disabled) {
			this.realElement.focus();
		}
	},
	onFakePressed: function(e){
		this.pressedFlag = true;
	},
	onFakeReleased: function(){
		this.pressedFlag = false;
	},
	onCreateModule: function(){
		// implement in subclass
	},
	onModuleAdded: function(module) {
		// implement in subclass
	},
	onControlReady: function() {
		// implement in subclass
	}
});

/*
 * JCF Utility Library
 */
jcf.lib = {
	bind: function(func, scope){
		return function() {
			return func.apply(scope, arguments);
		};
	},
	browser: (function() {
		var ua = navigator.userAgent.toLowerCase(), res = {},
		match = /(webkit)[ \/]([\w.]+)/.exec(ua) || /(opera)(?:.*version)?[ \/]([\w.]+)/.exec(ua) ||
				/(msie) ([\w.]+)/.exec(ua) || ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+))?/.exec(ua) || [];
		res[match[1]] = true;
		res.version = match[2] || "0";
		res.safariMac = ua.indexOf('mac') != -1 && ua.indexOf('safari') != -1;
		return res;
	})(),
	getOffset: function (obj) {
		if (obj.getBoundingClientRect && !jcf.isWinPhoneDevice) {
			var scrollLeft = window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft;
			var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
			var clientLeft = document.documentElement.clientLeft || document.body.clientLeft || 0;
			var clientTop = document.documentElement.clientTop || document.body.clientTop || 0;
			return {
				top:Math.round(obj.getBoundingClientRect().top + scrollTop - clientTop),
				left:Math.round(obj.getBoundingClientRect().left + scrollLeft - clientLeft)
			};
		} else {
			var posLeft = 0, posTop = 0;
			while (obj.offsetParent) {posLeft += obj.offsetLeft; posTop += obj.offsetTop; obj = obj.offsetParent;}
			return {top:posTop,left:posLeft};
		}
	},
	getScrollTop: function() {
		return window.pageYOffset || document.documentElement.scrollTop;
	},
	getScrollLeft: function() {
		return window.pageXOffset || document.documentElement.scrollLeft;
	},
	getWindowWidth: function(){
		return document.compatMode=='CSS1Compat' ? document.documentElement.clientWidth : document.body.clientWidth;
	},
	getWindowHeight: function(){
		return document.compatMode=='CSS1Compat' ? document.documentElement.clientHeight : document.body.clientHeight;
	},
	getStyle: function(el, prop) {
		if (document.defaultView && document.defaultView.getComputedStyle) {
			return document.defaultView.getComputedStyle(el, null)[prop];
		} else if (el.currentStyle) {
			return el.currentStyle[prop];
		} else {
			return el.style[prop];
		}
	},
	getParent: function(obj, selector) {
		while(obj.parentNode && obj.parentNode != document.body) {
			if(obj.parentNode.tagName.toLowerCase() == selector.toLowerCase()) {
				return obj.parentNode;
			}
			obj = obj.parentNode;
		}
		return false;
	},
	isParent: function(child, parent) {
		while(child.parentNode) {
			if(child.parentNode === parent) {
				return true;
			}
			child = child.parentNode;
		}
		return false;
	},
	getLabelFor: function(object) {
		var parentLabel = jcf.lib.getParent(object,'label');
		if(parentLabel) {
			return parentLabel;
		} else if(object.id) {
			return jcf.lib.queryBySelector('label[for="' + object.id + '"]')[0];
		}
	},
	disableTextSelection: function(el){
		if (typeof el.onselectstart !== 'undefined') {
			el.onselectstart = function() {return false;};
		} else if(window.opera) {
			el.setAttribute('unselectable', 'on');
		} else {
			jcf.lib.addClass(el, jcf.baseOptions.unselectableClass);
		}
	},
	enableTextSelection: function(el) {
		if (typeof el.onselectstart !== 'undefined') {
			el.onselectstart = null;
		} else if(window.opera) {
			el.removeAttribute('unselectable');
		} else {
			jcf.lib.removeClass(el, jcf.baseOptions.unselectableClass);
		}
	},
	queryBySelector: function(selector, scope){
		if(typeof scope === 'string') {
			var result = [];
			var holders = this.getElementsBySelector(scope);
			for (var i = 0, contextNodes; i < holders.length; i++) {
				contextNodes = Array.prototype.slice.call(this.getElementsBySelector(selector, holders[i]));
				result = result.concat(contextNodes);
			}
			return result;
		} else {
			return this.getElementsBySelector(selector, scope);
		}
	},
	prevSibling: function(node) {
		while(node = node.previousSibling) if(node.nodeType == 1) break;
		return node;
	},
	nextSibling: function(node) {
		while(node = node.nextSibling) if(node.nodeType == 1) break;
		return node;
	},
	fireEvent: function(element,event) {
		if(element.dispatchEvent){
			var evt = document.createEvent('HTMLEvents');
			evt.initEvent(event, true, true );
			return !element.dispatchEvent(evt);
		}else if(document.createEventObject){
			var evt = document.createEventObject();
			return element.fireEvent('on'+event,evt);
		}
	},
	isParent: function(p, c) {
		while(c.parentNode) {
			if(p == c) {
				return true;
			}
			c = c.parentNode;
		}
		return false;
	},
	inherit: function(Child, Parent) {
		var F = function() { }
		F.prototype = Parent.prototype
		Child.prototype = new F()
		Child.prototype.constructor = Child
		Child.superclass = Parent.prototype
	},
	extend: function(obj) {
		for(var i = 1; i < arguments.length; i++) {
			for(var p in arguments[i]) {
				if(arguments[i].hasOwnProperty(p)) {
					obj[p] = arguments[i][p];
				}
			}
		}
		return obj;
	},
	hasClass: function (obj,cname) {
		return (obj.className ? obj.className.match(new RegExp('(\\s|^)'+cname+'(\\s|$)')) : false);
	},
	addClass: function (obj,cname) {
		if (!this.hasClass(obj,cname)) obj.className += (!obj.className.length || obj.className.charAt(obj.className.length - 1) === ' ' ? '' : ' ') + cname;
	},
	removeClass: function (obj,cname) {
		if (this.hasClass(obj,cname)) obj.className=obj.className.replace(new RegExp('(\\s|^)'+cname+'(\\s|$)'),' ').replace(/\s+$/, '');
	},
	toggleClass: function(obj, cname, condition) {
		if(condition) this.addClass(obj, cname); else this.removeClass(obj, cname);
	},
	createElement: function(tagName, options) {
		var el = document.createElement(tagName);
		for(var p in options) {
			if(options.hasOwnProperty(p)) {
				switch (p) {
					case 'class': el.className = options[p]; break;
					case 'html': el.innerHTML = options[p]; break;
					case 'style': this.setStyles(el, options[p]); break;
					default: el.setAttribute(p, options[p]);
				}
			}
		}
		return el;
	},
	setStyles: function(el, styles) {
		for(var p in styles) {
			if(styles.hasOwnProperty(p)) {
				switch (p) {
					case 'float': el.style.cssFloat = styles[p]; break;
					case 'opacity': el.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity='+styles[p]*100+')'; el.style.opacity = styles[p]; break;
					default: el.style[p] = (typeof styles[p] === 'undefined' ? 0 : styles[p]) + (typeof styles[p] === 'number' ? 'px' : '');
				}
			}
		}
		return el;
	},
	getInnerWidth: function(el) {
		return el.offsetWidth - (parseInt(this.getStyle(el,'paddingLeft')) || 0) - (parseInt(this.getStyle(el,'paddingRight')) || 0);
	},
	getInnerHeight: function(el) {
		return el.offsetHeight - (parseInt(this.getStyle(el,'paddingTop')) || 0) - (parseInt(this.getStyle(el,'paddingBottom')) || 0);
	},
	getAllClasses: function(cname, prefix, skip) {
		if(!skip) skip = '';
		if(!prefix) prefix = '';
		return cname ? cname.replace(new RegExp('(\\s|^)'+skip+'(\\s|$)'),' ').replace(/[\s]*([\S]+)+[\s]*/gi,prefix+"$1 ") : '';
	},
	getElementsBySelector: function(selector, scope) {
		if(typeof document.querySelectorAll === 'function') {
			return (scope || document).querySelectorAll(selector);
		}
		var selectors = selector.split(',');
		var resultList = [];
		for(var s = 0; s < selectors.length; s++) {
			var currentContext = [scope || document];
			var tokens = selectors[s].replace(/^\s+/,'').replace(/\s+$/,'').split(' ');
			for (var i = 0; i < tokens.length; i++) {
				token = tokens[i].replace(/^\s+/,'').replace(/\s+$/,'');
				if (token.indexOf('#') > -1) {
					var bits = token.split('#'), tagName = bits[0], id = bits[1];
					var element = document.getElementById(id);
					if (tagName && element.nodeName.toLowerCase() != tagName) {
						return [];
					}
					currentContext = [element];
					continue;
				}
				if (token.indexOf('.') > -1) {
					var bits = token.split('.'), tagName = bits[0] || '*', className = bits[1], found = [], foundCount = 0;
					for (var h = 0; h < currentContext.length; h++) {
						var elements;
						if (tagName == '*') {
							elements = currentContext[h].getElementsByTagName('*');
						} else {
							elements = currentContext[h].getElementsByTagName(tagName);
						}
						for (var j = 0; j < elements.length; j++) {
							found[foundCount++] = elements[j];
						}
					}
					currentContext = [];
					var currentContextIndex = 0;
					for (var k = 0; k < found.length; k++) {
						if (found[k].className && found[k].className.match(new RegExp('(\\s|^)'+className+'(\\s|$)'))) {
							currentContext[currentContextIndex++] = found[k];
						}
					}
					continue;
				}
				if (token.match(/^(\w*)\[(\w+)([=~\|\^\$\*]?)=?"?([^\]"]*)"?\]$/)) {
					var tagName = RegExp.$1 || '*', attrName = RegExp.$2, attrOperator = RegExp.$3, attrValue = RegExp.$4;
					if(attrName.toLowerCase() == 'for' && this.browser.msie && this.browser.version < 8) {
						attrName = 'htmlFor';
					}
					var found = [], foundCount = 0;
					for (var h = 0; h < currentContext.length; h++) {
						var elements;
						if (tagName == '*') {
							elements = currentContext[h].getElementsByTagName('*');
						} else {
							elements = currentContext[h].getElementsByTagName(tagName);
						}
						for (var j = 0; elements[j]; j++) {
							found[foundCount++] = elements[j];
						}
					}
					currentContext = [];
					var currentContextIndex = 0, checkFunction;
					switch (attrOperator) {
						case '=': checkFunction = function(e) { return (e.getAttribute(attrName) == attrValue) }; break;
						case '~': checkFunction = function(e) { return (e.getAttribute(attrName).match(new RegExp('(\\s|^)'+attrValue+'(\\s|$)'))) }; break;
						case '|': checkFunction = function(e) { return (e.getAttribute(attrName).match(new RegExp('^'+attrValue+'-?'))) }; break;
						case '^': checkFunction = function(e) { return (e.getAttribute(attrName).indexOf(attrValue) == 0) }; break;
						case '$': checkFunction = function(e) { return (e.getAttribute(attrName).lastIndexOf(attrValue) == e.getAttribute(attrName).length - attrValue.length) }; break;
						case '*': checkFunction = function(e) { return (e.getAttribute(attrName).indexOf(attrValue) > -1) }; break;
						default : checkFunction = function(e) { return e.getAttribute(attrName) };
					}
					currentContext = [];
					var currentContextIndex = 0;
					for (var k = 0; k < found.length; k++) {
						if (checkFunction(found[k])) {
							currentContext[currentContextIndex++] = found[k];
						}
					}
					continue;
				}
				tagName = token;
				var found = [], foundCount = 0;
				for (var h = 0; h < currentContext.length; h++) {
					var elements = currentContext[h].getElementsByTagName(tagName);
					for (var j = 0; j < elements.length; j++) {
						found[foundCount++] = elements[j];
					}
				}
				currentContext = found;
			}
			resultList = [].concat(resultList,currentContext);
		}
		return resultList;
	},
	scrollSize: (function(){
		var content, hold, sizeBefore, sizeAfter;
		function buildSizer(){
			if(hold) removeSizer();
			content = document.createElement('div');
			hold = document.createElement('div');
			hold.style.cssText = 'position:absolute;overflow:hidden;width:100px;height:100px';
			hold.appendChild(content);
			document.body.appendChild(hold);
		}
		function removeSizer(){
			document.body.removeChild(hold);
			hold = null;
		}
		function calcSize(vertical) {
			buildSizer();
			content.style.cssText = 'height:'+(vertical ? '100%' : '200px');
			sizeBefore = (vertical ? content.offsetHeight : content.offsetWidth);
			hold.style.overflow = 'scroll'; content.innerHTML = 1;
			sizeAfter = (vertical ? content.offsetHeight : content.offsetWidth);
			if(vertical && hold.clientHeight) sizeAfter = hold.clientHeight;
			removeSizer();
			return sizeBefore - sizeAfter;
		}
		return {
			getWidth:function(){
				return calcSize(false);
			},
			getHeight:function(){
				return calcSize(true)
			}
		}
	}()),
	domReady: function (handler){
		var called = false
		function ready() {
			if (called) return;
			called = true;
			handler();
		}
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", ready, false);
		} else if (document.attachEvent) {
			if (document.documentElement.doScroll && window == window.top) {
				function tryScroll(){
					if (called) return
					if (!document.body) return
					try {
						document.documentElement.doScroll("left")
						ready()
					} catch(e) {
						setTimeout(tryScroll, 0)
					}
				}
				tryScroll()
			}
			document.attachEvent("onreadystatechange", function(){
				if (document.readyState === "complete") {
					ready()
				}
			})
		}
		if (window.addEventListener) window.addEventListener('load', ready, false)
		else if (window.attachEvent) window.attachEvent('onload', ready)
	},
	event: (function(){
		var guid = 0;
		function fixEvent(e) {
			e = e || window.event;
			if (e.isFixed) {
				return e;
			}
			e.isFixed = true; 
			e.preventDefault = e.preventDefault || function(){this.returnValue = false}
			e.stopPropagation = e.stopPropagaton || function(){this.cancelBubble = true}
			if (!e.target) {
				e.target = e.srcElement
			}
			if (!e.relatedTarget && e.fromElement) {
				e.relatedTarget = e.fromElement == e.target ? e.toElement : e.fromElement;
			}
			if (e.pageX == null && e.clientX != null) {
				var html = document.documentElement, body = document.body;
				e.pageX = e.clientX + (html && html.scrollLeft || body && body.scrollLeft || 0) - (html.clientLeft || 0);
				e.pageY = e.clientY + (html && html.scrollTop || body && body.scrollTop || 0) - (html.clientTop || 0);
			}
			if (!e.which && e.button) {
				e.which = e.button & 1 ? 1 : (e.button & 2 ? 3 : (e.button & 4 ? 2 : 0));
			}
			if(e.type === "DOMMouseScroll" || e.type === 'mousewheel') {
				e.mWheelDelta = 0;
				if (e.wheelDelta) {
					e.mWheelDelta = e.wheelDelta/120;
				} else if (e.detail) {
					e.mWheelDelta = -e.detail/3;
				}
			}
			return e;
		}
		function commonHandle(event, customScope) {
			event = fixEvent(event);
			var handlers = this.events[event.type];
			for (var g in handlers) {
				var handler = handlers[g];
				var ret = handler.call(customScope || this, event);
				if (ret === false) {
					event.preventDefault()
					event.stopPropagation()
				}
			}
		}
		var publicAPI = {
			add: function(elem, type, handler, forcedScope) {
				if (elem.setInterval && (elem != window && !elem.frameElement)) {
					elem = window;
				}
				if (!handler.guid) {
					handler.guid = ++guid;
				}
				if (!elem.events) {
					elem.events = {};
					elem.handle = function(event) {
						return commonHandle.call(elem, event);
					}
				}
				if (!elem.events[type]) {
					elem.events[type] = {};
					if (elem.addEventListener) elem.addEventListener(type, elem.handle, false);
					else if (elem.attachEvent) elem.attachEvent("on" + type, elem.handle);
					if(type === 'mousewheel') {
						publicAPI.add(elem, 'DOMMouseScroll', handler, forcedScope);
					}
				}
				var fakeHandler = jcf.lib.bind(handler, forcedScope);
				fakeHandler.guid = handler.guid;
				elem.events[type][handler.guid] = forcedScope ? fakeHandler : handler;
			},
			remove: function(elem, type, handler) {
				var handlers = elem.events && elem.events[type];
				if (!handlers) return;
				delete handlers[handler.guid];
				for(var any in handlers) return;
				if (elem.removeEventListener) elem.removeEventListener(type, elem.handle, false);
				else if (elem.detachEvent) elem.detachEvent("on" + type, elem.handle);
				delete elem.events[type];
				for (var any in elem.events) return;
				try {
					delete elem.handle;
					delete elem.events;
				} catch(e) {
					if(elem.removeAttribute) {
						elem.removeAttribute("handle");
						elem.removeAttribute("events");
					}
				}
				if(type === 'mousewheel') {
					publicAPI.remove(elem, 'DOMMouseScroll', handler);
				}
			}
		}
		return publicAPI;
	}())
}

// custom select module
jcf.addModule({
	name:'select',
	selector:'select',
	defaultOptions: {
		useNativeDropOnMobileDevices: true,
		hideDropOnScroll: true,
		showNativeDrop: false,
		handleDropPosition: false,
		selectDropPosition: 'bottom', // or 'top'
		wrapperClass:'select-area',
		focusClass:'select-focus',
		dropActiveClass:'select-active',
		selectedClass:'item-selected',
		currentSelectedClass:'current-selected',
		disabledClass:'select-disabled',
		valueSelector:'span.center', 
		optGroupClass:'optgroup',
		openerSelector:'a.select-opener',		
		selectStructure:'<span class="left"></span><span class="center"></span><a class="select-opener"></a>',
		wrapperTag: 'span',
		classPrefix:'select-',
		dropMaxHeight: 200,
		dropFlippedClass: 'select-options-flipped',
		dropHiddenClass:'options-hidden',
		dropScrollableClass:'options-overflow',
		dropClass:'select-options',
		dropClassPrefix:'drop-',
		dropStructure:'<div class="drop-holder"><div class="drop-list"></div></div>',
		dropSelector:'div.drop-list'
	},
	checkElement: function(el){
		return (!el.size && !el.multiple);
	},
	setupWrapper: function(){
		jcf.lib.addClass(this.fakeElement, this.options.wrapperClass);
		this.realElement.parentNode.insertBefore(this.fakeElement, this.realElement);
		this.fakeElement.innerHTML = this.options.selectStructure;
		this.fakeElement.style.width = (this.realElement.offsetWidth > 0 ? this.realElement.offsetWidth + 'px' : 'auto');

		// show native drop if specified in options
		if(this.options.useNativeDropOnMobileDevices && (jcf.isTouchDevice || jcf.isWinPhoneDevice)) {
			this.options.showNativeDrop = true;
		}
		if(this.options.showNativeDrop) {
			this.fakeElement.appendChild(this.realElement);
			jcf.lib.removeClass(this.realElement, this.options.hiddenClass);
			jcf.lib.setStyles(this.realElement, {
				top:0,
				left:0,
				margin:0,
				padding:0,
				opacity:0,
				border:'none',
				position:'absolute',
				width: jcf.lib.getInnerWidth(this.fakeElement) - 1,
				height: jcf.lib.getInnerHeight(this.fakeElement) - 1
			});
			jcf.lib.event.add(this.realElement, jcf.eventPress, function(){
				this.realElement.title = '';
			}, this)
		}
		
		// create select body
		this.opener = jcf.lib.queryBySelector(this.options.openerSelector, this.fakeElement)[0];
		this.valueText = jcf.lib.queryBySelector(this.options.valueSelector, this.fakeElement)[0];
		jcf.lib.disableTextSelection(this.valueText);
		this.opener.jcf = this;

		if(!this.options.showNativeDrop) {
			this.createDropdown();
			this.refreshState();
			this.onControlReady(this);
			this.hideDropdown(true);
		} else {
			this.refreshState();
		}
		this.addEvents();
	},
	addEvents: function(){
		if(this.options.showNativeDrop) {
			jcf.lib.event.add(this.realElement, 'click', this.onChange, this);
		} else {
			jcf.lib.event.add(this.fakeElement, 'click', this.toggleDropdown, this);
		}
		jcf.lib.event.add(this.realElement, 'change', this.onChange, this);
	},
	onFakeClick: function() {
		// do nothing (drop toggles by toggleDropdown method)
	},
	onFocus: function(){
		jcf.modules[this.name].superclass.onFocus.apply(this, arguments);
		if(!this.options.showNativeDrop) {
			// Mac Safari Fix
			if(jcf.lib.browser.safariMac) {
				this.realElement.setAttribute('size','2');
			}
			jcf.lib.event.add(this.realElement, 'keydown', this.onKeyDown, this);
			if(jcf.activeControl && jcf.activeControl != this) {
				jcf.activeControl.hideDropdown();
				jcf.activeControl = this;
			}
		}
	},
	onBlur: function(){
		if(!this.options.showNativeDrop) {
			// Mac Safari Fix
			if(jcf.lib.browser.safariMac) {
				this.realElement.removeAttribute('size');
			}
			if(!this.isActiveDrop() || !this.isOverDrop()) {
				jcf.modules[this.name].superclass.onBlur.apply(this);
				if(jcf.activeControl === this) jcf.activeControl = null;
				if(!jcf.isTouchDevice) {
					this.hideDropdown();
				}
			}
			jcf.lib.event.remove(this.realElement, 'keydown', this.onKeyDown);
		} else {
			jcf.modules[this.name].superclass.onBlur.apply(this);
		}
	},
	onChange: function() {
		this.refreshState();
	},
	onKeyDown: function(e){
		this.dropOpened = true;
		jcf.tmpFlag = true;
		setTimeout(function(){jcf.tmpFlag = false},100);
		var context = this;
		context.keyboardFix = true;
		setTimeout(function(){
			context.refreshState();
		},10);
		if(e.keyCode == 13) {
			context.toggleDropdown.apply(context);
			return false;
		}
	},
	onResizeWindow: function(e){
		if(this.isActiveDrop()) {
			this.hideDropdown();
		}
	},
	onScrollWindow: function(e){
		if(this.options.hideDropOnScroll) {
			this.hideDropdown();
		} else if(this.isActiveDrop()) {
			this.positionDropdown();
		}
	},
	onOptionClick: function(e){
		var opener = e.target && e.target.tagName && e.target.tagName.toLowerCase() == 'li' ? e.target : jcf.lib.getParent(e.target, 'li');
		if(opener) {
			this.dropOpened = true;
			this.realElement.selectedIndex = parseInt(opener.getAttribute('rel'));
			if(jcf.isTouchDevice) {
				this.onFocus();
			} else {
				this.realElement.focus();
			}
			this.refreshState();
			this.hideDropdown();
			jcf.lib.fireEvent(this.realElement, 'change');
		}
		return false;
	},
	onClickOutside: function(e){
		if(jcf.tmpFlag) {
			jcf.tmpFlag = false;
			return;
		}
		if(!jcf.lib.isParent(this.fakeElement, e.target) && !jcf.lib.isParent(this.selectDrop, e.target)) {
			this.hideDropdown();
		}
	},
	onDropHover: function(e){
		if(!this.keyboardFix) {
			this.hoverFlag = true;
			var opener = e.target && e.target.tagName && e.target.tagName.toLowerCase() == 'li' ? e.target : jcf.lib.getParent(e.target, 'li');
			if(opener) {
				this.realElement.selectedIndex = parseInt(opener.getAttribute('rel'));
				this.refreshSelectedClass(parseInt(opener.getAttribute('rel')));
			}
		} else {
			this.keyboardFix = false;
		}
	},
	onDropLeave: function(){
		this.hoverFlag = false;
	},
	isActiveDrop: function(){
		return !jcf.lib.hasClass(this.selectDrop, this.options.dropHiddenClass);
	},
	isOverDrop: function(){
		return this.hoverFlag;
	},
	createDropdown: function(){
		// remove old dropdown if exists
		if(this.selectDrop) {
			this.selectDrop.parentNode.removeChild(this.selectDrop);
		}

		// create dropdown holder
		this.selectDrop = document.createElement('div');
		this.selectDrop.className = this.options.dropClass;
		this.selectDrop.innerHTML = this.options.dropStructure;
		jcf.lib.setStyles(this.selectDrop, {position:'absolute'});
		this.selectList = jcf.lib.queryBySelector(this.options.dropSelector,this.selectDrop)[0];
		jcf.lib.addClass(this.selectDrop, this.options.dropHiddenClass);
		document.body.appendChild(this.selectDrop);
		this.selectDrop.jcf = this;
		jcf.lib.event.add(this.selectDrop, 'click', this.onOptionClick, this);
		jcf.lib.event.add(this.selectDrop, 'mouseover', this.onDropHover, this);
		jcf.lib.event.add(this.selectDrop, 'mouseout', this.onDropLeave, this);
		this.buildDropdown();
	},
	buildDropdown: function() {
		// build select options / optgroups
		this.buildDropdownOptions();

		// position and resize dropdown
		this.positionDropdown();

		// cut dropdown if height exceedes
		this.buildDropdownScroll();
	},
	buildDropdownOptions: function() {
		this.resStructure = '';
		this.optNum = 0;
		for(var i = 0; i < this.realElement.children.length; i++) {
			this.resStructure += this.buildElement(this.realElement.children[i], i) +'\n';
		}
		this.selectList.innerHTML = this.resStructure;
	},
	buildDropdownScroll: function() {
		if(this.options.dropMaxHeight) {
			if(this.selectDrop.offsetHeight > this.options.dropMaxHeight) {
				this.selectList.style.height = this.options.dropMaxHeight+'px';
				this.selectList.style.overflow = 'auto';
				this.selectList.style.overflowX = 'hidden';
				jcf.lib.addClass(this.selectDrop, this.options.dropScrollableClass);
			}
		}
		jcf.lib.addClass(this.selectDrop, jcf.lib.getAllClasses(this.realElement.className, this.options.dropClassPrefix, jcf.baseOptions.hiddenClass));
	},
	parseOptionTitle: function(optTitle) {
		return (typeof optTitle === 'string' && /\.(jpg|gif|png|bmp|jpeg)(.*)?$/i.test(optTitle)) ? optTitle : '';
	},
	buildElement: function(obj, index){
		// build option
		var res = '', optImage;
		if(obj.tagName.toLowerCase() == 'option') {
			if(!jcf.lib.prevSibling(obj) || jcf.lib.prevSibling(obj).tagName.toLowerCase() != 'option') {
				res += '<ul>';
			}
			
			optImage = this.parseOptionTitle(obj.title);
			res += '<li rel="'+(this.optNum++)+'" class="'+(obj.className? obj.className + ' ' : '')+(index % 2 ? 'option-even ' : '')+'jcfcalc"><a href="#">'+(optImage ? '<img src="'+optImage+'" alt="" />' : '')+'<span>' + obj.innerHTML + '</span></a></li>';
			if(!jcf.lib.nextSibling(obj) || jcf.lib.nextSibling(obj).tagName.toLowerCase() != 'option') {
				res += '</ul>';
			}
			return res;
		}
		// build option group with options
		else if(obj.tagName.toLowerCase() == 'optgroup' && obj.label) {
			res += '<div class="'+this.options.optGroupClass+'">';
			res += '<strong class="jcfcalc"><em>'+(obj.label)+'</em></strong>';
			for(var i = 0; i < obj.children.length; i++) {
				res += this.buildElement(obj.children[i], i);
			}
			res += '</div>';
			return res;
		}
	},
	positionDropdown: function(){
		var ofs = jcf.lib.getOffset(this.fakeElement), selectAreaHeight = this.fakeElement.offsetHeight, selectDropHeight = this.selectDrop.offsetHeight;
		var fitInTop = ofs.top - selectDropHeight >= jcf.lib.getScrollTop() && jcf.lib.getScrollTop() + jcf.lib.getWindowHeight() < ofs.top + selectAreaHeight + selectDropHeight;
		
		
		if((this.options.handleDropPosition && fitInTop) || this.options.selectDropPosition === 'top') {
			this.selectDrop.style.top = (ofs.top - selectDropHeight)+'px';
			jcf.lib.addClass(this.selectDrop, this.options.dropFlippedClass);
			jcf.lib.addClass(this.fakeElement, this.options.dropFlippedClass);
		} else {
			this.selectDrop.style.top = (ofs.top + selectAreaHeight)+'px';
			jcf.lib.removeClass(this.selectDrop, this.options.dropFlippedClass);
			jcf.lib.removeClass(this.fakeElement, this.options.dropFlippedClass);
		}
		this.selectDrop.style.left = ofs.left+'px';
		this.selectDrop.style.width = this.fakeElement.offsetWidth+'px';
	},
	showDropdown: function(){
		document.body.appendChild(this.selectDrop);
		jcf.lib.removeClass(this.selectDrop, this.options.dropHiddenClass);
		jcf.lib.addClass(this.fakeElement,this.options.dropActiveClass);
		this.positionDropdown();

		// highlight current active item
		var activeItem = this.getFakeActiveOption();
		this.removeClassFromItems(this.options.currentSelectedClass);
		jcf.lib.addClass(activeItem, this.options.currentSelectedClass);
		
		// show current dropdown
		jcf.lib.event.add(window, 'resize', this.onResizeWindow, this);
		jcf.lib.event.add(window, 'scroll', this.onScrollWindow, this);
		jcf.lib.event.add(document, jcf.eventPress, this.onClickOutside, this);
		this.positionDropdown();
	},
	hideDropdown: function(partial){
		if(this.selectDrop.parentNode) {
			if(this.selectDrop.offsetWidth) {
				this.selectDrop.parentNode.removeChild(this.selectDrop);
			}
			if(partial) {
				return;
			}
		}
		if(typeof this.origSelectedIndex === 'number') {
			this.realElement.selectedIndex = this.origSelectedIndex;
		}
		jcf.lib.removeClass(this.fakeElement,this.options.dropActiveClass);
		jcf.lib.addClass(this.selectDrop, this.options.dropHiddenClass);
		jcf.lib.event.remove(window, 'resize', this.onResizeWindow);
		jcf.lib.event.remove(window, 'scroll', this.onScrollWindow);
		jcf.lib.event.remove(document.documentElement, jcf.eventPress, this.onClickOutside);
		if(jcf.isTouchDevice) {
			this.onBlur();
		}
	},
	toggleDropdown: function(){
		if(!this.realElement.disabled) {
			if(jcf.isTouchDevice) {
				this.onFocus();
			} else {
				this.realElement.focus();
			}
			if(this.isActiveDrop()) {
				this.hideDropdown();
			} else {
				this.showDropdown();
			}
			this.refreshState();
		}
	},
	scrollToItem: function(){
		if(this.isActiveDrop()) {
			var dropHeight = this.selectList.offsetHeight;
			var offsetTop = this.calcOptionOffset(this.getFakeActiveOption());
			var sTop = this.selectList.scrollTop;
			var oHeight = this.getFakeActiveOption().offsetHeight;
			//offsetTop+=sTop;

			if(offsetTop >= sTop + dropHeight) {
				this.selectList.scrollTop = offsetTop - dropHeight + oHeight;
			} else if(offsetTop < sTop) {
				this.selectList.scrollTop = offsetTop;
			}
		}
	},
	getFakeActiveOption: function(c) {
		return jcf.lib.queryBySelector('li[rel="'+(typeof c === 'number' ? c : this.realElement.selectedIndex) +'"]',this.selectList)[0];
	},
	calcOptionOffset: function(fake) {
		var h = 0;
		var els = jcf.lib.queryBySelector('.jcfcalc',this.selectList);
		for(var i = 0; i < els.length; i++) {
			if(els[i] == fake) break;
			h+=els[i].offsetHeight;
		}
		return h;
	},
	childrenHasItem: function(hold,item) {
		var items = hold.getElementsByTagName('*');
		for(i = 0; i < items.length; i++) {
			if(items[i] == item) return true;
		}
		return false;
	},
	removeClassFromItems: function(className){
		var children = jcf.lib.queryBySelector('li',this.selectList);
		for(var i = children.length - 1; i >= 0; i--) {
			jcf.lib.removeClass(children[i], className);
		}
	},
	setSelectedClass: function(c){
		jcf.lib.addClass(this.getFakeActiveOption(c), this.options.selectedClass);
	},
	refreshSelectedClass: function(c){
		if(!this.options.showNativeDrop) {
			this.removeClassFromItems(this.options.selectedClass);
			this.setSelectedClass(c);
		}
		if(this.realElement.disabled) {
			jcf.lib.addClass(this.fakeElement, this.options.disabledClass);
			if(this.labelFor) {
				jcf.lib.addClass(this.labelFor, this.options.labelDisabledClass);
			}
		} else {
			jcf.lib.removeClass(this.fakeElement, this.options.disabledClass);
			if(this.labelFor) {
				jcf.lib.removeClass(this.labelFor, this.options.labelDisabledClass);
			}
		}
	},
	refreshSelectedText: function() {
		if(!this.dropOpened && this.realElement.title) {
			this.valueText.innerHTML = this.realElement.title;
		} else {
			if(this.realElement.options[this.realElement.selectedIndex].title) {
				var optImage = this.parseOptionTitle(this.realElement.options[this.realElement.selectedIndex].title);
				this.valueText.innerHTML = (optImage ? '<img src="'+optImage+'" alt="" />' : '') + this.realElement.options[this.realElement.selectedIndex].innerHTML;
			} else {
				this.valueText.innerHTML = this.realElement.options[this.realElement.selectedIndex].innerHTML;
			}
		}
	},
	refreshState: function(){
		this.origSelectedIndex = this.realElement.selectedIndex;
		this.refreshSelectedClass();
		this.refreshSelectedText();
		if(!this.options.showNativeDrop) {
			this.positionDropdown();
			if(this.selectDrop.offsetWidth) {
				this.scrollToItem();
			}
		}
	}
});


// placeholder class
;(function(){
	var placeholderCollection = [];
	PlaceholderInput = function() {
		this.options = {
			element:null,
			showUntilTyping:false,
			wrapWithElement:false,
			getParentByClass:false,
			showPasswordBullets:false,
			placeholderAttr:'value',
			inputFocusClass:'focus',
			inputActiveClass:'text-active',
			parentFocusClass:'parent-focus',
			parentActiveClass:'parent-active',
			labelFocusClass:'label-focus',
			labelActiveClass:'label-active',
			fakeElementClass:'input-placeholder-text'
		};
		placeholderCollection.push(this);
		this.init.apply(this,arguments);
	};
	PlaceholderInput.refreshAllInputs = function(except) {
		for(var i = 0; i < placeholderCollection.length; i++) {
			if(except !== placeholderCollection[i]) {
				placeholderCollection[i].refreshState();
			}
		}
	};
	PlaceholderInput.replaceByOptions = function(opt) {
		var inputs = [].concat(
			convertToArray(document.getElementsByTagName('input')),
			convertToArray(document.getElementsByTagName('textarea'))
		);
		for(var i = 0; i < inputs.length; i++) {
			if(inputs[i].className.indexOf(opt.skipClass) < 0) {
				var inputType = getInputType(inputs[i]);
				var placeholderValue = inputs[i].getAttribute('placeholder');
				if(opt.focusOnly || (opt.clearInputs && (inputType === 'text' || inputType === 'email' || placeholderValue)) ||
					(opt.clearTextareas && inputType === 'textarea') ||
					(opt.clearPasswords && inputType === 'password')
				) {
					new PlaceholderInput({
						element:inputs[i],
						focusOnly: opt.focusOnly,
						wrapWithElement:opt.wrapWithElement,
						showUntilTyping:opt.showUntilTyping,
						getParentByClass:opt.getParentByClass,
						showPasswordBullets:opt.showPasswordBullets,
						placeholderAttr: placeholderValue ? 'placeholder' : opt.placeholderAttr
					});
				}
			}
		}
	};
	PlaceholderInput.prototype = {
		init: function(opt) {
			this.setOptions(opt);
			if(this.element && this.element.PlaceholderInst) {
				this.element.PlaceholderInst.refreshClasses();
			} else {
				this.element.PlaceholderInst = this;
				if(this.elementType !== 'radio' || this.elementType !== 'checkbox' || this.elementType !== 'file') {
					this.initElements();
					this.attachEvents();
					this.refreshClasses();
				}
			}
		},
		setOptions: function(opt) {
			for(var p in opt) {
				if(opt.hasOwnProperty(p)) {
					this.options[p] = opt[p];
				}
			}
			if(this.options.element) {
				this.element = this.options.element;
				this.elementType = getInputType(this.element);
				if(this.options.focusOnly) {
					this.wrapWithElement = false;
				} else {
					if(this.elementType === 'password' && this.options.showPasswordBullets) {
						this.wrapWithElement = false;
					} else {
						this.wrapWithElement = this.elementType === 'password' || this.options.showUntilTyping ? true : this.options.wrapWithElement;
					}
				}
				this.setPlaceholderValue(this.options.placeholderAttr);
			}
		},
		setPlaceholderValue: function(attr) {
			this.origValue = (attr === 'value' ? this.element.defaultValue : (this.element.getAttribute(attr) || ''));
			if(this.options.placeholderAttr !== 'value') {
				this.element.removeAttribute(this.options.placeholderAttr);
			}
		},
		initElements: function() {
			// create fake element if needed
			if(this.wrapWithElement) {
				this.fakeElement = document.createElement('span');
				this.fakeElement.className = this.options.fakeElementClass;
				this.fakeElement.innerHTML += this.origValue;
				this.fakeElement.style.color = getStyle(this.element, 'color');
				this.fakeElement.style.position = 'absolute';
				this.element.parentNode.insertBefore(this.fakeElement, this.element);
				
				if(this.element.value === this.origValue || !this.element.value) {
					this.element.value = '';
					this.togglePlaceholderText(true);
				} else {
					this.togglePlaceholderText(false);
				}
			} else if(!this.element.value && this.origValue.length) {
				this.element.value = this.origValue;
			}
			// get input label
			if(this.element.id) {
				this.labels = document.getElementsByTagName('label');
				for(var i = 0; i < this.labels.length; i++) {
					if(this.labels[i].htmlFor === this.element.id) {
						this.labelFor = this.labels[i];
						break;
					}
				}
			}
			// get parent node (or parentNode by className)
			this.elementParent = this.element.parentNode;
			if(typeof this.options.getParentByClass === 'string') {
				var el = this.element;
				while(el.parentNode) {
					if(hasClass(el.parentNode, this.options.getParentByClass)) {
						this.elementParent = el.parentNode;
						break;
					} else {
						el = el.parentNode;
					}
				}
			}
		},
		attachEvents: function() {
			this.element.onfocus = bindScope(this.focusHandler, this);
			this.element.onblur = bindScope(this.blurHandler, this);
			if(this.options.showUntilTyping) {
				this.element.onkeydown = bindScope(this.typingHandler, this);
				this.element.onpaste = bindScope(this.typingHandler, this);
			}
			if(this.wrapWithElement) this.fakeElement.onclick = bindScope(this.focusSetter, this);
		},
		togglePlaceholderText: function(state) {
			if(!this.element.readOnly && !this.options.focusOnly) {
				if(this.wrapWithElement) {
					this.fakeElement.style.display = state ? '' : 'none';
				} else {
					this.element.value = state ? this.origValue : '';
				}
			}
		},
		focusSetter: function() {
			this.element.focus();
		},
		focusHandler: function() {
			clearInterval(this.checkerInterval);
			this.checkerInterval = setInterval(bindScope(this.intervalHandler,this), 1);
			this.focused = true;
			if(!this.element.value.length || this.element.value === this.origValue) {
				if(!this.options.showUntilTyping) {
					this.togglePlaceholderText(false);
				}
			}
			this.refreshClasses();
		},
		blurHandler: function() {
			clearInterval(this.checkerInterval);
			this.focused = false;
			if(!this.element.value.length || this.element.value === this.origValue) {
				this.togglePlaceholderText(true);
			}
			this.refreshClasses();
			PlaceholderInput.refreshAllInputs(this);
		},
		typingHandler: function() {
			setTimeout(bindScope(function(){
				if(this.element.value.length) {
					this.togglePlaceholderText(false);
					this.refreshClasses();
				}
			},this), 10);
		},
		intervalHandler: function() {
			if(typeof this.tmpValue === 'undefined') {
				this.tmpValue = this.element.value;
			}
			if(this.tmpValue != this.element.value) {
				PlaceholderInput.refreshAllInputs(this);
			}
		},
		refreshState: function() {
			if(this.wrapWithElement) {
				if(this.element.value.length && this.element.value !== this.origValue) {
					this.togglePlaceholderText(false);
				} else if(!this.element.value.length) {
					this.togglePlaceholderText(true);
				}
			}
			this.refreshClasses();
		},
		refreshClasses: function() {
			this.textActive = this.focused || (this.element.value.length && this.element.value !== this.origValue);
			this.setStateClass(this.element, this.options.inputFocusClass,this.focused);
			this.setStateClass(this.elementParent, this.options.parentFocusClass,this.focused);
			this.setStateClass(this.labelFor, this.options.labelFocusClass,this.focused);
			this.setStateClass(this.element, this.options.inputActiveClass, this.textActive);
			this.setStateClass(this.elementParent, this.options.parentActiveClass, this.textActive);
			this.setStateClass(this.labelFor, this.options.labelActiveClass, this.textActive);
		},
		setStateClass: function(el,cls,state) {
			if(!el) return; else if(state) addClass(el,cls); else removeClass(el,cls);
		}
	};
	
	// utility functions
	function convertToArray(collection) {
		var arr = [];
		for (var i = 0, ref = arr.length = collection.length; i < ref; i++) {
			arr[i] = collection[i];
		}
		return arr;
	}
	function getInputType(input) {
		return (input.type ? input.type : input.tagName).toLowerCase();
	}
	function hasClass(el,cls) {
		return el.className ? el.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)')) : false;
	}
	function addClass(el,cls) {
		if (!hasClass(el,cls)) el.className += " "+cls;
	}
	function removeClass(el,cls) {
		if (hasClass(el,cls)) {el.className=el.className.replace(new RegExp('(\\s|^)'+cls+'(\\s|$)'),' ');}
	}
	function bindScope(f, scope) {
		return function() {return f.apply(scope, arguments);};
	}
	function getStyle(el, prop) {
		if (document.defaultView && document.defaultView.getComputedStyle) {
			return document.defaultView.getComputedStyle(el, null)[prop];
		} else if (el.currentStyle) {
			return el.currentStyle[prop];
		} else {
			return el.style[prop];
		}
	}
}());

/*! Hammer.JS - v1.0.5 - 2013-04-07
 * http://eightmedia.github.com/hammer.js
 *
 * Copyright (c) 2013 Jorik Tangelder <j.tangelder@gmail.com>;
 * Licensed under the MIT license */
;(function(t,e){"use strict";function n(){if(!i.READY){i.event.determineEventTypes();for(var t in i.gestures)i.gestures.hasOwnProperty(t)&&i.detection.register(i.gestures[t]);i.event.onTouch(i.DOCUMENT,i.EVENT_MOVE,i.detection.detect),i.event.onTouch(i.DOCUMENT,i.EVENT_END,i.detection.detect),i.READY=!0}}var i=function(t,e){return new i.Instance(t,e||{})};i.defaults={stop_browser_behavior:{userSelect:"none",touchAction:"none",touchCallout:"none",contentZooming:"none",userDrag:"none",tapHighlightColor:"rgba(0,0,0,0)"}},i.HAS_POINTEREVENTS=navigator.pointerEnabled||navigator.msPointerEnabled,i.HAS_TOUCHEVENTS="ontouchstart"in t,i.MOBILE_REGEX=/mobile|tablet|ip(ad|hone|od)|android/i,i.NO_MOUSEEVENTS=i.HAS_TOUCHEVENTS&&navigator.userAgent.match(i.MOBILE_REGEX),i.EVENT_TYPES={},i.DIRECTION_DOWN="down",i.DIRECTION_LEFT="left",i.DIRECTION_UP="up",i.DIRECTION_RIGHT="right",i.POINTER_MOUSE="mouse",i.POINTER_TOUCH="touch",i.POINTER_PEN="pen",i.EVENT_START="start",i.EVENT_MOVE="move",i.EVENT_END="end",i.DOCUMENT=document,i.plugins={},i.READY=!1,i.Instance=function(t,e){var r=this;return n(),this.element=t,this.enabled=!0,this.options=i.utils.extend(i.utils.extend({},i.defaults),e||{}),this.options.stop_browser_behavior&&i.utils.stopDefaultBrowserBehavior(this.element,this.options.stop_browser_behavior),i.event.onTouch(t,i.EVENT_START,function(t){r.enabled&&i.detection.startDetect(r,t)}),this},i.Instance.prototype={on:function(t,e){for(var n=t.split(" "),i=0;n.length>i;i++)this.element.addEventListener(n[i],e,!1);return this},off:function(t,e){for(var n=t.split(" "),i=0;n.length>i;i++)this.element.removeEventListener(n[i],e,!1);return this},trigger:function(t,e){var n=i.DOCUMENT.createEvent("Event");n.initEvent(t,!0,!0),n.gesture=e;var r=this.element;return i.utils.hasParent(e.target,r)&&(r=e.target),r.dispatchEvent(n),this},enable:function(t){return this.enabled=t,this}};var r=null,o=!1,s=!1;i.event={bindDom:function(t,e,n){for(var i=e.split(" "),r=0;i.length>r;r++)t.addEventListener(i[r],n,!1)},onTouch:function(t,e,n){var a=this;this.bindDom(t,i.EVENT_TYPES[e],function(c){var u=c.type.toLowerCase();if(!u.match(/mouse/)||!s){(u.match(/touch/)||u.match(/pointerdown/)||u.match(/mouse/)&&1===c.which)&&(o=!0),u.match(/touch|pointer/)&&(s=!0);var h=0;o&&(i.HAS_POINTEREVENTS&&e!=i.EVENT_END?h=i.PointerEvent.updatePointer(e,c):u.match(/touch/)?h=c.touches.length:s||(h=u.match(/up/)?0:1),h>0&&e==i.EVENT_END?e=i.EVENT_MOVE:h||(e=i.EVENT_END),h||null===r?r=c:c=r,n.call(i.detection,a.collectEventData(t,e,c)),i.HAS_POINTEREVENTS&&e==i.EVENT_END&&(h=i.PointerEvent.updatePointer(e,c))),h||(r=null,o=!1,s=!1,i.PointerEvent.reset())}})},determineEventTypes:function(){var t;t=i.HAS_POINTEREVENTS?i.PointerEvent.getEvents():i.NO_MOUSEEVENTS?["touchstart","touchmove","touchend touchcancel"]:["touchstart mousedown","touchmove mousemove","touchend touchcancel mouseup"],i.EVENT_TYPES[i.EVENT_START]=t[0],i.EVENT_TYPES[i.EVENT_MOVE]=t[1],i.EVENT_TYPES[i.EVENT_END]=t[2]},getTouchList:function(t){return i.HAS_POINTEREVENTS?i.PointerEvent.getTouchList():t.touches?t.touches:[{identifier:1,pageX:t.pageX,pageY:t.pageY,target:t.target}]},collectEventData:function(t,e,n){var r=this.getTouchList(n,e),o=i.POINTER_TOUCH;return(n.type.match(/mouse/)||i.PointerEvent.matchType(i.POINTER_MOUSE,n))&&(o=i.POINTER_MOUSE),{center:i.utils.getCenter(r),timeStamp:(new Date).getTime(),target:n.target,touches:r,eventType:e,pointerType:o,srcEvent:n,preventDefault:function(){this.srcEvent.preventManipulation&&this.srcEvent.preventManipulation(),this.srcEvent.preventDefault&&this.srcEvent.preventDefault()},stopPropagation:function(){this.srcEvent.stopPropagation()},stopDetect:function(){return i.detection.stopDetect()}}}},i.PointerEvent={pointers:{},getTouchList:function(){var t=this,e=[];return Object.keys(t.pointers).sort().forEach(function(n){e.push(t.pointers[n])}),e},updatePointer:function(t,e){return t==i.EVENT_END?this.pointers={}:(e.identifier=e.pointerId,this.pointers[e.pointerId]=e),Object.keys(this.pointers).length},matchType:function(t,e){if(!e.pointerType)return!1;var n={};return n[i.POINTER_MOUSE]=e.pointerType==e.MSPOINTER_TYPE_MOUSE||e.pointerType==i.POINTER_MOUSE,n[i.POINTER_TOUCH]=e.pointerType==e.MSPOINTER_TYPE_TOUCH||e.pointerType==i.POINTER_TOUCH,n[i.POINTER_PEN]=e.pointerType==e.MSPOINTER_TYPE_PEN||e.pointerType==i.POINTER_PEN,n[t]},getEvents:function(){return["pointerdown MSPointerDown","pointermove MSPointerMove","pointerup pointercancel MSPointerUp MSPointerCancel"]},reset:function(){this.pointers={}}},i.utils={extend:function(t,n,i){for(var r in n)t[r]!==e&&i||(t[r]=n[r]);return t},hasParent:function(t,e){for(;t;){if(t==e)return!0;t=t.parentNode}return!1},getCenter:function(t){for(var e=[],n=[],i=0,r=t.length;r>i;i++)e.push(t[i].pageX),n.push(t[i].pageY);return{pageX:(Math.min.apply(Math,e)+Math.max.apply(Math,e))/2,pageY:(Math.min.apply(Math,n)+Math.max.apply(Math,n))/2}},getVelocity:function(t,e,n){return{x:Math.abs(e/t)||0,y:Math.abs(n/t)||0}},getAngle:function(t,e){var n=e.pageY-t.pageY,i=e.pageX-t.pageX;return 180*Math.atan2(n,i)/Math.PI},getDirection:function(t,e){var n=Math.abs(t.pageX-e.pageX),r=Math.abs(t.pageY-e.pageY);return n>=r?t.pageX-e.pageX>0?i.DIRECTION_LEFT:i.DIRECTION_RIGHT:t.pageY-e.pageY>0?i.DIRECTION_UP:i.DIRECTION_DOWN},getDistance:function(t,e){var n=e.pageX-t.pageX,i=e.pageY-t.pageY;return Math.sqrt(n*n+i*i)},getScale:function(t,e){return t.length>=2&&e.length>=2?this.getDistance(e[0],e[1])/this.getDistance(t[0],t[1]):1},getRotation:function(t,e){return t.length>=2&&e.length>=2?this.getAngle(e[1],e[0])-this.getAngle(t[1],t[0]):0},isVertical:function(t){return t==i.DIRECTION_UP||t==i.DIRECTION_DOWN},stopDefaultBrowserBehavior:function(t,e){var n,i=["webkit","khtml","moz","ms","o",""];if(e&&t.style){for(var r=0;i.length>r;r++)for(var o in e)e.hasOwnProperty(o)&&(n=o,i[r]&&(n=i[r]+n.substring(0,1).toUpperCase()+n.substring(1)),t.style[n]=e[o]);"none"==e.userSelect&&(t.onselectstart=function(){return!1})}}},i.detection={gestures:[],current:null,previous:null,stopped:!1,startDetect:function(t,e){this.current||(this.stopped=!1,this.current={inst:t,startEvent:i.utils.extend({},e),lastEvent:!1,name:""},this.detect(e))},detect:function(t){if(this.current&&!this.stopped){t=this.extendEventData(t);for(var e=this.current.inst.options,n=0,r=this.gestures.length;r>n;n++){var o=this.gestures[n];if(!this.stopped&&e[o.name]!==!1&&o.handler.call(o,t,this.current.inst)===!1){this.stopDetect();break}}return this.current&&(this.current.lastEvent=t),t.eventType==i.EVENT_END&&!t.touches.length-1&&this.stopDetect(),t}},stopDetect:function(){this.previous=i.utils.extend({},this.current),this.current=null,this.stopped=!0},extendEventData:function(t){var e=this.current.startEvent;if(e&&(t.touches.length!=e.touches.length||t.touches===e.touches)){e.touches=[];for(var n=0,r=t.touches.length;r>n;n++)e.touches.push(i.utils.extend({},t.touches[n]))}var o=t.timeStamp-e.timeStamp,s=t.center.pageX-e.center.pageX,a=t.center.pageY-e.center.pageY,c=i.utils.getVelocity(o,s,a);return i.utils.extend(t,{deltaTime:o,deltaX:s,deltaY:a,velocityX:c.x,velocityY:c.y,distance:i.utils.getDistance(e.center,t.center),angle:i.utils.getAngle(e.center,t.center),direction:i.utils.getDirection(e.center,t.center),scale:i.utils.getScale(e.touches,t.touches),rotation:i.utils.getRotation(e.touches,t.touches),startEvent:e}),t},register:function(t){var n=t.defaults||{};return n[t.name]===e&&(n[t.name]=!0),i.utils.extend(i.defaults,n,!0),t.index=t.index||1e3,this.gestures.push(t),this.gestures.sort(function(t,e){return t.index<e.index?-1:t.index>e.index?1:0}),this.gestures}},i.gestures=i.gestures||{},i.gestures.Hold={name:"hold",index:10,defaults:{hold_timeout:500,hold_threshold:1},timer:null,handler:function(t,e){switch(t.eventType){case i.EVENT_START:clearTimeout(this.timer),i.detection.current.name=this.name,this.timer=setTimeout(function(){"hold"==i.detection.current.name&&e.trigger("hold",t)},e.options.hold_timeout);break;case i.EVENT_MOVE:t.distance>e.options.hold_threshold&&clearTimeout(this.timer);break;case i.EVENT_END:clearTimeout(this.timer)}}},i.gestures.Tap={name:"tap",index:100,defaults:{tap_max_touchtime:250,tap_max_distance:10,tap_always:!0,doubletap_distance:20,doubletap_interval:300},handler:function(t,e){if(t.eventType==i.EVENT_END){var n=i.detection.previous,r=!1;if(t.deltaTime>e.options.tap_max_touchtime||t.distance>e.options.tap_max_distance)return;n&&"tap"==n.name&&t.timeStamp-n.lastEvent.timeStamp<e.options.doubletap_interval&&t.distance<e.options.doubletap_distance&&(e.trigger("doubletap",t),r=!0),(!r||e.options.tap_always)&&(i.detection.current.name="tap",e.trigger(i.detection.current.name,t))}}},i.gestures.Swipe={name:"swipe",index:40,defaults:{swipe_max_touches:1,swipe_velocity:.7},handler:function(t,e){if(t.eventType==i.EVENT_END){if(e.options.swipe_max_touches>0&&t.touches.length>e.options.swipe_max_touches)return;(t.velocityX>e.options.swipe_velocity||t.velocityY>e.options.swipe_velocity)&&(e.trigger(this.name,t),e.trigger(this.name+t.direction,t))}}},i.gestures.Drag={name:"drag",index:50,defaults:{drag_min_distance:10,drag_max_touches:1,drag_block_horizontal:!1,drag_block_vertical:!1,drag_lock_to_axis:!1,drag_lock_min_distance:25},triggered:!1,handler:function(t,n){if(i.detection.current.name!=this.name&&this.triggered)return n.trigger(this.name+"end",t),this.triggered=!1,e;if(!(n.options.drag_max_touches>0&&t.touches.length>n.options.drag_max_touches))switch(t.eventType){case i.EVENT_START:this.triggered=!1;break;case i.EVENT_MOVE:if(t.distance<n.options.drag_min_distance&&i.detection.current.name!=this.name)return;i.detection.current.name=this.name,(i.detection.current.lastEvent.drag_locked_to_axis||n.options.drag_lock_to_axis&&n.options.drag_lock_min_distance<=t.distance)&&(t.drag_locked_to_axis=!0);var r=i.detection.current.lastEvent.direction;t.drag_locked_to_axis&&r!==t.direction&&(t.direction=i.utils.isVertical(r)?0>t.deltaY?i.DIRECTION_UP:i.DIRECTION_DOWN:0>t.deltaX?i.DIRECTION_LEFT:i.DIRECTION_RIGHT),this.triggered||(n.trigger(this.name+"start",t),this.triggered=!0),n.trigger(this.name,t),n.trigger(this.name+t.direction,t),(n.options.drag_block_vertical&&i.utils.isVertical(t.direction)||n.options.drag_block_horizontal&&!i.utils.isVertical(t.direction))&&t.preventDefault();break;case i.EVENT_END:this.triggered&&n.trigger(this.name+"end",t),this.triggered=!1}}},i.gestures.Transform={name:"transform",index:45,defaults:{transform_min_scale:.01,transform_min_rotation:1,transform_always_block:!1},triggered:!1,handler:function(t,n){if(i.detection.current.name!=this.name&&this.triggered)return n.trigger(this.name+"end",t),this.triggered=!1,e;if(!(2>t.touches.length))switch(n.options.transform_always_block&&t.preventDefault(),t.eventType){case i.EVENT_START:this.triggered=!1;break;case i.EVENT_MOVE:var r=Math.abs(1-t.scale),o=Math.abs(t.rotation);if(n.options.transform_min_scale>r&&n.options.transform_min_rotation>o)return;i.detection.current.name=this.name,this.triggered||(n.trigger(this.name+"start",t),this.triggered=!0),n.trigger(this.name,t),o>n.options.transform_min_rotation&&n.trigger("rotate",t),r>n.options.transform_min_scale&&(n.trigger("pinch",t),n.trigger("pinch"+(1>t.scale?"in":"out"),t));break;case i.EVENT_END:this.triggered&&n.trigger(this.name+"end",t),this.triggered=!1}}},i.gestures.Touch={name:"touch",index:-1/0,defaults:{prevent_default:!1,prevent_mouseevents:!1},handler:function(t,n){return n.options.prevent_mouseevents&&t.pointerType==i.POINTER_MOUSE?(t.stopDetect(),e):(n.options.prevent_default&&t.preventDefault(),t.eventType==i.EVENT_START&&n.trigger(this.name,t),e)}},i.gestures.Release={name:"release",index:1/0,handler:function(t,e){t.eventType==i.EVENT_END&&e.trigger(this.name,t)}},"object"==typeof module&&"object"==typeof module.exports?module.exports=i:(t.Hammer=i,"function"==typeof t.define&&t.define.amd&&t.define("hammer",[],function(){return i}))})(this),function(t,e){"use strict";t!==e&&(Hammer.event.bindDom=function(n,i,r){t(n).on(i,function(t){var n=t.originalEvent||t;n.pageX===e&&(n.pageX=t.pageX,n.pageY=t.pageY),n.target||(n.target=t.target),n.which===e&&(n.which=n.button),n.preventDefault||(n.preventDefault=t.preventDefault),n.stopPropagation||(n.stopPropagation=t.stopPropagation),r.call(this,n)})},Hammer.Instance.prototype.on=function(e,n){return t(this.element).on(e,n)},Hammer.Instance.prototype.off=function(e,n){return t(this.element).off(e,n)},Hammer.Instance.prototype.trigger=function(e,n){var i=t(this.element);return i.has(n.target).length&&(i=t(n.target)),i.trigger({type:e,gesture:n})},t.fn.hammer=function(e){return this.each(function(){var n=t(this),i=n.data("hammer");i?i&&e&&Hammer.utils.extend(i.options,e):n.data("hammer",new Hammer(this,e||{}))})})}(window.jQuery||window.Zepto);