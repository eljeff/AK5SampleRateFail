//
//  ViewController.swift
//  ak5tests
//
//  Created by Jeff Cooper on 4/16/21.
//

import AVFoundation
import AudioKit
import UIKit

class ViewController: UIViewController {

    private var sampler = Sampler()
    private var osc = Oscillator(waveform: Table(.sawtooth), frequency: 220)
    private var mixer = Mixer()
    private var engine = AudioEngine()
    private var session = AVAudioSession.sharedInstance()

    private var fs1 = 44_100.0
    private var fs2 = 48_000.0

    @IBOutlet weak var sessionRateLabel: UILabel!
    @IBOutlet weak var settingsRateLabel: UILabel!
    @IBOutlet weak var engineRunningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSampler()
        setupRoute()
        updateRateLabels()
    }

    private func updateRateLabels() {
        updateRateLabels(sessionSampleRate: session.sampleRate, settingsSampleRate: Settings.sampleRate)
    }

    private func updateRateLabels(sessionSampleRate: Double, settingsSampleRate: Double) {
        DispatchQueue.main.async {[weak self] in
            self?.sessionRateLabel.text = "\(sessionSampleRate)"
            self?.settingsRateLabel.text = "\(settingsSampleRate)"
            self?.engineRunningLabel.text = "\(self?.engine.avEngine.isRunning ?? false)"
        }
    }
    @IBAction func startEnginTapped(_ sender: UIButton) {
        startEngine()
        updateRateLabels()
    }

    @IBAction func stopEngineTapped(_ sender: UIButton) {
        stopEngine()
        updateRateLabels()
    }

    @IBAction func toggleSessionRateTapped(_ sender: UIButton) {
        toggleSessionRate()
        updateRateLabels()
    }

    @IBAction func toggleSettingsRateTapped(_ sender: UIButton) {
        toggleSettingsRate()
        updateRateLabels()
    }

    @IBAction func toggleNoteTapped(_ sender: UIButton) {
        sampler.play(noteNumber: 48, velocity: 100)
    }
    @IBAction func toggleNoteRelease(_ sender: UIButton) {
        sampler.stop(noteNumber: 48)
    }

    @IBAction func toggleOscTapped(_ sender: UIButton) {
        osc.start()
    }
    @IBAction func toggleOscRelease(_ sender: UIButton) {
        osc.stop()
    }

    private func setupSampler() {
        sampler.loadSFZ(url: Bundle.main.url(forResource: "Sounds/Sampler Instruments/simpleSqr.sfz", withExtension: nil)!)
        sampler.attackDuration = 0.001
        sampler.releaseDuration = 1.0
        sampler.loopThruRelease = true
    }

    private func setupRoute() {
        mixer.addInput(osc)
        mixer.addInput(sampler)
        engine.output = mixer
    }

    private func toggleSettingsRate() {
        setSettingsSampleRate(Settings.sampleRate == fs1 ? fs2 : fs1)
    }

    private func toggleSessionRate() {
        setSessionSampleRate(session.sampleRate == fs1 ? fs2 : fs1)
    }

    private func setSettingsSampleRate(_ rate: Double) {
        print(#function + " - \(rate)")
        Settings.sampleRate = rate
    }

    private func setSessionSampleRate(_ rate: Double) {
        print(#function + " - \(rate)")
        do {
            try session.setPreferredSampleRate(rate)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func startEngine() {
        print(#function)
        osc.stop()
        do {
            try engine.start()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func stopEngine() {
        print(#function)
        osc.stop()
        engine.stop()
    }

}

