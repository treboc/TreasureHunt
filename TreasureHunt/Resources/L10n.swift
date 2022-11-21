// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Plural format key: "%#@stationsCounter@"
  internal static func huntListRowViewStationsCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "huntListRowViewStationsCount", p1, fallback: "Plural format key: \"%#@stationsCounter@\"")
  }
  internal enum A11yLabel {
    /// Create Hunt
    internal static let createHunt = L10n.tr("Localizable", "a11yLabel.createHunt", fallback: "Create Hunt")
  }
  internal enum AddHuntView {
    /// Chosen Stations (%@ / 50)
    internal static func chosenStations(_ p1: Any) -> String {
      return L10n.tr("Localizable", "addHuntView.chosenStations %@", String(describing: p1), fallback: "Chosen Stations (%@ / 50)")
    }
    /// Chose Stations
    internal static let editStations = L10n.tr("Localizable", "addHuntView.editStations", fallback: "Chose Stations")
    /// Name of the Hunt
    internal static let name = L10n.tr("Localizable", "addHuntView.name", fallback: "Name of the Hunt")
    /// Kids Birthday Party 🎁
    internal static let namePlaceholder = L10n.tr("Localizable", "addHuntView.namePlaceholder", fallback: "Kids Birthday Party 🎁")
    /// New Hunt
    internal static let navTitle = L10n.tr("Localizable", "addHuntView.navTitle", fallback: "New Hunt")
    /// No Stations Chosen
    internal static let noChosenStations = L10n.tr("Localizable", "addHuntView.noChosenStations", fallback: "No Stations Chosen")
    /// Overview
    internal static let overview = L10n.tr("Localizable", "addHuntView.overview", fallback: "Overview")
    /// Overview of all Stations
    internal static let stationsOverview = L10n.tr("Localizable", "addHuntView.stationsOverview", fallback: "Overview of all Stations")
  }
  internal enum AddStationView {
    /// New Station
    internal static let navTitle = L10n.tr("Localizable", "addStationView.navTitle", fallback: "New Station")
    internal enum DetailPage {
      /// Add a name.
      internal static let description = L10n.tr("Localizable", "addStationView.detailPage.description", fallback: "Add a name.")
      /// z.B. At the old mill
      internal static let nameTextFieldPlaceholder = L10n.tr("Localizable", "addStationView.detailPage.nameTextFieldPlaceholder", fallback: "z.B. At the old mill")
      /// Name of the Station
      internal static let nameTextFieldTitle = L10n.tr("Localizable", "addStationView.detailPage.nameTextFieldTitle", fallback: "Name of the Station")
      /// 2. Details
      internal static let title = L10n.tr("Localizable", "addStationView.detailPage.title", fallback: "2. Details")
    }
    internal enum PagePicker {
      /// Details
      internal static let details = L10n.tr("Localizable", "addStationView.pagePicker.details", fallback: "Details")
      /// Position
      internal static let position = L10n.tr("Localizable", "addStationView.pagePicker.position", fallback: "Position")
    }
    internal enum PositionPage {
      /// Move the map, so that the center is at this point where the station sould be.
      internal static let description = L10n.tr("Localizable", "addStationView.positionPage.description", fallback: "Move the map, so that the center is at this point where the station sould be.")
      /// 1. Position
      internal static let title = L10n.tr("Localizable", "addStationView.positionPage.title", fallback: "1. Position")
    }
    internal enum TriggerDistanceSlider {
      /// Defines from which distance a station is triggered.
      internal static let a11yHint = L10n.tr("Localizable", "addStationView.triggerDistanceSlider.a11yHint", fallback: "Defines from which distance a station is triggered.")
      /// Distance Slider
      internal static let a11yLabel = L10n.tr("Localizable", "addStationView.triggerDistanceSlider.a11yLabel", fallback: "Distance Slider")
      /// Minimum Distance: %@
      internal static func a11yValue(_ p1: Any) -> String {
        return L10n.tr("Localizable", "addStationView.triggerDistanceSlider.a11yValue %@", String(describing: p1), fallback: "Minimum Distance: %@")
      }
      /// Distance to the station, that must be fallen short to trigger the station.
      internal static let description = L10n.tr("Localizable", "addStationView.triggerDistanceSlider.description", fallback: "Distance to the station, that must be fallen short to trigger the station.")
      /// Min. Distance
      internal static let minDistance = L10n.tr("Localizable", "addStationView.triggerDistanceSlider.minDistance", fallback: "Min. Distance")
    }
  }
  internal enum Alert {
    internal enum DeleteHunt {
      /// The selected hunt will be deleted. This cannot be undone.
      internal static let message = L10n.tr("Localizable", "alert.deleteHunt.message", fallback: "The selected hunt will be deleted. This cannot be undone.")
      /// Are you sure?
      internal static let title = L10n.tr("Localizable", "alert.deleteHunt.title", fallback: "Are you sure?")
    }
    internal enum DeleteStation {
      /// The selected station will be deleted and removed from any hunt that used this station. This cannot be undone.
      internal static let message = L10n.tr("Localizable", "alert.deleteStation.message", fallback: "The selected station will be deleted and removed from any hunt that used this station. This cannot be undone.")
      /// Are you sure?
      internal static let title = L10n.tr("Localizable", "alert.deleteStation.title", fallback: "Are you sure?")
    }
  }
  internal enum BtnTitle {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "btnTitle.cancel", fallback: "Cancel")
    /// Delete
    internal static let delete = L10n.tr("Localizable", "btnTitle.delete", fallback: "Delete")
    /// Edit
    internal static let edit = L10n.tr("Localizable", "btnTitle.edit", fallback: "Edit")
    /// Yes, I'm sure.
    internal static let iAmSure = L10n.tr("Localizable", "btnTitle.iAmSure", fallback: "Yes, I'm sure.")
    /// Save
    internal static let save = L10n.tr("Localizable", "btnTitle.save", fallback: "Save")
  }
  internal enum HuntListDetailRowView {
    /// Distance
    internal static let distanceFromHere = L10n.tr("Localizable", "huntListDetailRowView.distanceFromHere", fallback: "Distance")
    /// Question
    internal static let question = L10n.tr("Localizable", "huntListDetailRowView.question", fallback: "Question")
    /// Stations Name
    internal static let stationName = L10n.tr("Localizable", "huntListDetailRowView.stationName", fallback: "Stations Name")
  }
  internal enum HuntListDetailView {
    /// Created On
    internal static let createdAt = L10n.tr("Localizable", "huntListDetailView.createdAt", fallback: "Created On")
    /// Name
    internal static let huntName = L10n.tr("Localizable", "huntListDetailView.huntName", fallback: "Name")
    /// Edit Hunt
    internal static let noStationsEditHuntButtonTitle = L10n.tr("Localizable", "huntListDetailView.noStationsEditHuntButtonTitle", fallback: "Edit Hunt")
    /// This hunt has no stations yet, please at atleast one.
    internal static let noStationsPlaceholderText = L10n.tr("Localizable", "huntListDetailView.noStationsPlaceholderText", fallback: "This hunt has no stations yet, please at atleast one.")
    /// Start Hunt
    internal static let startHuntButtonTitle = L10n.tr("Localizable", "huntListDetailView.startHuntButtonTitle", fallback: "Start Hunt")
  }
  internal enum HuntListRowView {
    /// Created: 
    internal static let created = L10n.tr("Localizable", "huntListRowView.created", fallback: "Created: ")
  }
  internal enum HuntListView {
    /// Create a Hunt
    internal static let listPlaceholderButtonTitle = L10n.tr("Localizable", "huntListView.listPlaceholderButtonTitle", fallback: "Create a Hunt")
    /// You've not added any hunt yet. To create your first hunt, tap here or the "+" in the top right corner.
    internal static let listPlaceholderText = L10n.tr("Localizable", "huntListView.listPlaceholderText", fallback: "You've not added any hunt yet. To create your first hunt, tap here or the \"+\" in the top right corner.")
  }
  internal enum HuntView {
    /// End Hunt
    internal static let endHuntButtonTitle = L10n.tr("Localizable", "huntView.endHuntButtonTitle", fallback: "End Hunt")
    /// Next Station
    internal static let nextStationButtonTitle = L10n.tr("Localizable", "huntView.nextStationButtonTitle", fallback: "Next Station")
    internal enum DirectionDistanceView {
      /// Distance N/A
      internal static let distanceNA = L10n.tr("Localizable", "huntView.directionDistanceView.distanceNA", fallback: "Distance N/A")
      /// No Station
      internal static let stationNameFallback = L10n.tr("Localizable", "huntView.directionDistanceView.stationNameFallback", fallback: "No Station")
      /// Station %@ of %@.
      internal static func stationOf(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "huntView.directionDistanceView.stationOf %@ %@", String(describing: p1), String(describing: p2), fallback: "Station %@ of %@.")
      }
    }
    internal enum EndHuntAlert {
      /// That will end the hunt. Your progress won't be saved.
      internal static let message = L10n.tr("Localizable", "huntView.endHuntAlert.message", fallback: "That will end the hunt. Your progress won't be saved.")
      /// Are you sure?
      internal static let title = L10n.tr("Localizable", "huntView.endHuntAlert.title", fallback: "Are you sure?")
    }
    internal enum QuestionView {
      /// Done!
      internal static let doneButtonTitle = L10n.tr("Localizable", "huntView.questionView.doneButtonTitle", fallback: "Done!")
      /// Question
      internal static let question = L10n.tr("Localizable", "huntView.questionView.question", fallback: "Question")
      /// %@ reached!
      internal static func reachedStation(_ p1: Any) -> String {
        return L10n.tr("Localizable", "huntView.questionView.reachedStation %@", String(describing: p1), fallback: "%@ reached!")
      }
    }
    internal enum TrafficWarningView {
      /// Agree
      internal static let buttonTitle = L10n.tr("Localizable", "huntView.trafficWarningView.buttonTitle", fallback: "Agree")
      /// Always be aware of your surroundings and traffic when on a hunt.
      internal static let message = L10n.tr("Localizable", "huntView.trafficWarningView.message", fallback: "Always be aware of your surroundings and traffic when on a hunt.")
      /// Caution!
      internal static let title = L10n.tr("Localizable", "huntView.trafficWarningView.title", fallback: "Caution!")
    }
  }
  internal enum LocationsListRowView {
    /// No question on this station.
    internal static let noQuestion = L10n.tr("Localizable", "locationsListRowView.noQuestion", fallback: "No question on this station.")
  }
  internal enum LocationsListView {
    /// Tip: Tap on a location to show an edit sheet for this location.
    internal static let editStationTooltip = L10n.tr("Localizable", "locationsListView.editStationTooltip", fallback: "Tip: Tap on a location to show an edit sheet for this location.")
    /// Create a Location
    internal static let listPlaceholderButtonTitle = L10n.tr("Localizable", "locationsListView.listPlaceholderButtonTitle", fallback: "Create a Location")
    /// You've not added any location yet. To create your first location, tap here or the "+" in the top right corner.
    internal static let listPlaceholderText = L10n.tr("Localizable", "locationsListView.listPlaceholderText", fallback: "You've not added any location yet. To create your first location, tap here or the \"+\" in the top right corner.")
    /// Locations
    internal static let navTitle = L10n.tr("Localizable", "locationsListView.navTitle", fallback: "Locations")
    internal enum SwipeAction {
      /// Toggle Location as Favorite
      internal static let markFavorite = L10n.tr("Localizable", "locationsListView.swipeAction.markFavorite", fallback: "Toggle Location as Favorite")
    }
  }
  internal enum MainTabView {
    internal enum TabItem {
      /// Hunts
      internal static let huntList = L10n.tr("Localizable", "mainTabView.tabItem.huntList", fallback: "Hunts")
      /// Settings
      internal static let settings = L10n.tr("Localizable", "mainTabView.tabItem.settings", fallback: "Settings")
      /// Locations
      internal static let stationList = L10n.tr("Localizable", "mainTabView.tabItem.stationList", fallback: "Locations")
    }
  }
  internal enum SettingsView {
    /// Haptic Feedback
    internal static let hapticsToggleTitle = L10n.tr("Localizable", "settingsView.hapticsToggleTitle", fallback: "Haptic Feedback")
    /// The display will not shut down while hunting, if this option is activated.
    internal static let idleDimmingToggleDescription = L10n.tr("Localizable", "settingsView.idleDimmingToggleDescription", fallback: "The display will not shut down while hunting, if this option is activated.")
    /// Disable Display Dimming
    internal static let idleDimmingToggleTitle = L10n.tr("Localizable", "settingsView.idleDimmingToggleTitle", fallback: "Disable Display Dimming")
    /// Settings
    internal static let navTitle = L10n.tr("Localizable", "settingsView.navTitle", fallback: "Settings")
    /// Sound
    internal static let soundToggleTitle = L10n.tr("Localizable", "settingsView.soundToggleTitle", fallback: "Sound")
    internal enum AppearancePicker {
      /// Dark
      internal static let dark = L10n.tr("Localizable", "settingsView.appearancePicker.dark", fallback: "Dark")
      /// Light
      internal static let light = L10n.tr("Localizable", "settingsView.appearancePicker.light", fallback: "Light")
      /// System
      internal static let system = L10n.tr("Localizable", "settingsView.appearancePicker.system", fallback: "System")
      /// Color Scheme
      internal static let title = L10n.tr("Localizable", "settingsView.appearancePicker.title", fallback: "Color Scheme")
    }
    internal enum ArrowPicker {
      /// Arrow
      internal static let arrow = L10n.tr("Localizable", "settingsView.arrowPicker.arrow", fallback: "Arrow")
      /// Arrow (merged)
      internal static let arrowMerged = L10n.tr("Localizable", "settingsView.arrowPicker.arrowMerged", fallback: "Arrow (merged)")
      /// Location
      internal static let locationNorth = L10n.tr("Localizable", "settingsView.arrowPicker.locationNorth", fallback: "Location")
      /// Location (filled)
      internal static let locationNorthFill = L10n.tr("Localizable", "settingsView.arrowPicker.locationNorthFill", fallback: "Location (filled)")
      /// Arrow Icon
      internal static let title = L10n.tr("Localizable", "settingsView.arrowPicker.title", fallback: "Arrow Icon")
      /// Triangle (filled)
      internal static let triangleFill = L10n.tr("Localizable", "settingsView.arrowPicker.triangleFill", fallback: "Triangle (filled)")
      /// Triangle (outlined)
      internal static let triangleOutlined = L10n.tr("Localizable", "settingsView.arrowPicker.triangleOutlined", fallback: "Triangle (outlined)")
    }
    internal enum LegalNoticeView {
      /// Legal Notice
      internal static let navTitle = L10n.tr("Localizable", "settingsView.legalNoticeView.navTitle", fallback: "Legal Notice")
    }
  }
  internal enum SimpleConstants {
    /// Localizable.strings
    ///   TreasureHunt
    /// 
    ///   Created by Marvin Lee Kobert on 15.10.22.
    internal static let hunt = L10n.tr("Localizable", "simpleConstants.hunt", fallback: "Hunts")
    /// Hunt
    internal static let hunts = L10n.tr("Localizable", "simpleConstants.hunts", fallback: "Hunt")
    /// Station
    internal static let station = L10n.tr("Localizable", "simpleConstants.station", fallback: "Station")
    /// Stations
    internal static let stations = L10n.tr("Localizable", "simpleConstants.stations", fallback: "Stations")
  }
  internal enum StationsPicker {
    /// Create Station
    internal static let addStationButtonTitle = L10n.tr("Localizable", "stationsPicker.addStationButtonTitle", fallback: "Create Station")
    /// Available Stations
    internal static let availableStations = L10n.tr("Localizable", "stationsPicker.availableStations", fallback: "Available Stations")
    /// Stations Picker
    internal static let navTitle = L10n.tr("Localizable", "stationsPicker.navTitle", fallback: "Stations Picker")
    /// No Station Chosen Yet
    internal static let noChosenStations = L10n.tr("Localizable", "stationsPicker.noChosenStations", fallback: "No Station Chosen Yet")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
