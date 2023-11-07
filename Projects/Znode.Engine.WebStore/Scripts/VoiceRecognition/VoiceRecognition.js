var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var VoiceRecognitionModel = /** @class */ (function () {
    function VoiceRecognitionModel() {
        this.encoder = null;
        this.wav_format = false;
        this.windowWeb = window;
        this.result_mode = true ? 'asr' : 'file';
        this.outfilename_wav = "outputvoice.wav";
        this.outfilename_flac = "outputvoice.flac";
        this.navigatorObject = window['navigator'];
        this.samplerate = 16000;
        this.language = 'en-US';
        this.alternatives = 20;
        this.google_api_key = "AIzaSyCwtVWGYQq-ddfvjV25NWOGIJGeW50opgE";
        this.google_api_url = "https://speech.googleapis.com/v1/speech:recognize";
        this.recording = false;
        this.stream = null;
        this.autoSelectSamplerate = true;
        this.flacdata = { bps: 16, channels: 1, compression: 5 };
        this.compression = 5;
        this.audio_context = null;
    }
    return VoiceRecognitionModel;
}());
var input = null;
var node = null;
var objVoiceRec = new VoiceRecognitionModel();
var VoiceRecognition = /** @class */ (function (_super) {
    __extends(VoiceRecognition, _super);
    function VoiceRecognition() {
        return _super.call(this) || this;
    }
    VoiceRecognition.prototype.startRecording = function (isChromeSpecific, regionName, callBackFunction) {
        if (isChromeSpecific) {
            ChromeVoiceRecognition.prototype.startRecording(regionName, callBackFunction);
        }
        else {
            VoiceRecognition.prototype.startGoogleSpeechRecording(callBackFunction);
        }
    };
    VoiceRecognition.prototype.startGoogleSpeechRecording = function (callBackFunction) {
        objVoiceRec.encoder = new Worker('Scripts/lib/VoiceRecognition/encoder.min.js');
        if (objVoiceRec.wav_format == true) {
            objVoiceRec.encoder.postMessage({ cmd: 'save_as_wavfile' });
        }
        objVoiceRec.encoder.onmessage = function (e) {
            VoiceRecognition.prototype.doProcessEncoderMessage(e, callBackFunction);
        };
        if (objVoiceRec.navigatorObject.webkitGetUserMedia)
            objVoiceRec.navigatorObject.webkitGetUserMedia({ video: false, audio: true }, VoiceRecognition.prototype.gotUserMedia, VoiceRecognition.prototype.userMediaFailed);
        else if (objVoiceRec.navigatorObject.mozGetUserMedia)
            objVoiceRec.navigatorObject.mozGetUserMedia({ video: false, audio: true }, VoiceRecognition.prototype.gotUserMedia, VoiceRecognition.prototype.userMediaFailed);
        else
            objVoiceRec.navigatorObject.getUserMedia({ video: false, audio: true }, VoiceRecognition.prototype.gotUserMedia, VoiceRecognition.prototype.userMediaFailed);
    };
    VoiceRecognition.prototype.doProcessEncoderMessage = function (e, callBackFunction) {
        if (e.data.cmd == 'end') {
            var resultMode = objVoiceRec.result_mode;
            if (resultMode === 'file') {
                var fname = objVoiceRec.wav_format ? objVoiceRec.outfilename_wav : objVoiceRec.outfilename_flac;
                VoiceRecognition.prototype.forceDownload(e.data.buf, fname);
            }
            else if (resultMode === 'asr') {
                if (objVoiceRec.wav_format) {
                    //can only use FLAC format (not WAVE)!
                    console.error('Can only use FLAC format for speech recognition!');
                }
                else {
                    VoiceRecognition.prototype.sendASRRequest(e.data.buf, callBackFunction);
                }
            }
            else {
                console.error('Unknown mode for processing STOP RECORDING event: "' + resultMode + '"!');
            }
            objVoiceRec.encoder.terminate();
            objVoiceRec.encoder = null;
        }
        else if (e.data.cmd == 'debug') {
            console.log(e.data);
        }
        else {
            console.error('Unknown event from encoder (WebWorker): "' + e.data.cmd + '"!');
        }
    };
    ;
    VoiceRecognition.prototype.stopRecording = function () {
        if (!objVoiceRec.recording) {
            return;
        }
        console.log('stop recording');
        var tracks = objVoiceRec.stream.getAudioTracks();
        for (var i = tracks.length - 1; i >= 0; --i) {
            tracks[i].stop();
        }
        objVoiceRec.recording = false;
        objVoiceRec.encoder.postMessage({ cmd: 'finish' });
        input.disconnect();
        node.disconnect();
        input = node = null;
    };
    VoiceRecognition.prototype.forceDownload = function (blob, filename) {
        var url = (objVoiceRec.windowWeb.URL || objVoiceRec.windowWeb.webkitURL).createObjectURL(blob);
        var link = objVoiceRec.windowWeb.document.createElement('a');
        link.href = url;
        link.download = filename || 'output.flac';
        //NOTE: FireFox requires a MouseEvent (in Chrome a simple Event would do the trick)
        var click = document.createEvent("MouseEvent");
        click.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        link.dispatchEvent(click);
    };
    VoiceRecognition.prototype.sendASRRequest = function (blob, callBackFun) {
        // use FileReader to convert Blob to base64 encoded data-URL
        var reader = new objVoiceRec.windowWeb.FileReader();
        reader.readAsDataURL(blob);
        reader.onloadend = function () {
            VoiceRecognition.prototype.googleSpeechAPI(reader.result.replace(/^data:audio\/flac;base64,/, ''), callBackFun);
        };
    };
    VoiceRecognition.prototype.googleSpeechAPI = function (audioData, callBackFun) {
        //only use base64-encoded data, i.e. remove meta-data from beginning:        
        var data = {
            config: {
                encoding: "FLAC",
                sampleRateHertz: objVoiceRec.samplerate,
                languageCode: objVoiceRec.language,
                maxAlternatives: objVoiceRec.alternatives
            },
            audio: {
                content: audioData
            }
        };
        var oAjaxReq = new XMLHttpRequest();
        oAjaxReq.onload = function () {
            try {
                var result = this.responseText;
                var index = 0;
                var i = 0;
                var convertedText = "";
                result = JSON.parse(result);
                var maxconfidence = 0;
                if (result.results.length > 0) {
                    for (index = 0; index < result.results.length; ++index) {
                        for (i = 0; i < result.results[index].alternatives.length; ++i) {
                            if (result.results[index].alternatives[i].confidence > maxconfidence) {
                                maxconfidence = result.results[index].alternatives[i].confidence;
                                convertedText = result.results[index].alternatives[i].transcript;
                            }
                        }
                    }
                }
                if (callBackFun != null)
                    callBackFun(convertedText);
            }
            catch (exc) {
                console.log('Could not parse result into JSON object: "' + result + '"');
            }
        };
        oAjaxReq.open("post", objVoiceRec.google_api_url + "?key=" + objVoiceRec.google_api_key, true);
        oAjaxReq.setRequestHeader("Content-Type", "application/json");
        oAjaxReq.send(JSON.stringify(data));
    };
    VoiceRecognition.prototype.gotUserMedia = function (localMediaStream) {
        objVoiceRec.recording = true;
        console.log('success grabbing microphone');
        objVoiceRec.stream = localMediaStream;
        if (typeof objVoiceRec.windowWeb.webkitAudioContext !== 'undefined') {
            objVoiceRec.audio_context = new objVoiceRec.windowWeb.webkitAudioContext;
        }
        else if (typeof AudioContext !== 'undefined') {
            objVoiceRec.audio_context = new AudioContext;
        }
        else {
            console.error('JavaScript execution environment (Browser) does not support AudioContext interface.');
            console.log('Could not start recording audio:\n Web Audio is not supported by your browser!');
            return;
        }
        input = objVoiceRec.audio_context.createMediaStreamSource(objVoiceRec.stream);
        if (objVoiceRec.windowWeb.input.context.createJavaScriptNode)
            node = objVoiceRec.windowWeb.input.context.createJavaScriptNode(4096, 1, 1);
        else if (objVoiceRec.windowWeb.input.context.createScriptProcessor)
            node = objVoiceRec.windowWeb.input.context.createScriptProcessor(4096, 1, 1);
        else
            console.error('Could not create audio node for JavaScript based Audio Processing.');
        var sampleRate1 = objVoiceRec.audio_context.sampleRate;
        console.log('audioContext.sampleRate: ' + sampleRate1); //DEBUG
        if (objVoiceRec.autoSelectSamplerate) {
            objVoiceRec.samplerate = sampleRate1;
        }
        console.log('initializing encoder with:'); //DEBUG
        console.log(' bits-per-sample = ' + objVoiceRec.flacdata.bps); //DEBUG
        console.log(' channels        = ' + objVoiceRec.flacdata.channels); //DEBUG
        console.log(' sample rate     = ' + objVoiceRec.samplerate); //DEBUG
        console.log(' compression     = ' + objVoiceRec.compression); //DEBUG
        objVoiceRec.encoder.postMessage({ cmd: 'init', config: { samplerate: objVoiceRec.samplerate, bps: objVoiceRec.flacdata.bps, channels: objVoiceRec.flacdata.channels, compression: objVoiceRec.compression } });
        node.onaudioprocess = function (e) {
            if (!objVoiceRec.recording)
                return;
            // see also: http://typedarray.org/from-microphone-to-wav-with-getusermedia-and-web-audio/
            var channelLeft = e.inputBuffer.getChannelData(0);
            // var channelRight = e.inputBuffer.getChannelData(1);
            objVoiceRec.encoder.postMessage({ cmd: 'encode', buf: channelLeft });
        };
        input.connect(node);
        node.connect(objVoiceRec.audio_context.destination);
    };
    ;
    VoiceRecognition.prototype.userMediaFailed = function (code) {
        console.log('grabbing microphone failed: ' + code);
    };
    ;
    return VoiceRecognition;
}(ZnodeBase));
var ChromeVoiceRecognition = /** @class */ (function (_super) {
    __extends(ChromeVoiceRecognition, _super);
    function ChromeVoiceRecognition() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    ChromeVoiceRecognition.prototype.startRecording = function (regionName, callBackFunction) {
        var recognizer = new objVoiceRec.windowWeb.webkitSpeechRecognition();
        recognizer.lang = regionName;
        recognizer.onresult = function (event) {
            ChromeVoiceRecognition.prototype.doProcessOnResult(event, callBackFunction);
        };
        recognizer.start();
    };
    ChromeVoiceRecognition.prototype.doProcessOnResult = function (event, callBackFunction) {
        if (event.results.length > 0) {
            var result = event.results[event.results.length - 1];
            if (result.isFinal) {
                if (callBackFunction != null) {
                    callBackFunction(result[0].transcript);
                }
            }
        }
    };
    return ChromeVoiceRecognition;
}(ZnodeBase));
//# sourceMappingURL=VoiceRecognition.js.map