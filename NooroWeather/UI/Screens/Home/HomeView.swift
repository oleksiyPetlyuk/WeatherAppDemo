//
//  HomeView.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import SwiftUI

struct HomeView: View {
    @State private(set) var viewModel: HomeViewModel
    @Environment(\.isPreview) var isPreview

    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText) {
                Task { await viewModel.searchCities() }
            }

            Spacer()

            switch viewModel.state {
            case .none:
                EmptyView()
            case .loading:
                ProgressView()
            case .empty:
                EmptyStateView()
            case .loaded(let city):
                LoadedStateView(city: city)
            case .searchResults(let cities):
                if cities.isEmpty {
                    Text("No Cities Were Found")
                        .font(.poppins(.regular, 20))
                        .foregroundStyle(.labelPrimary)
                        .multilineTextAlignment(.center)
                } else {
                    List(cities) { city in
                        CitySearchResultView(city: city) {
                            Task { await viewModel.saveCity(city) }
                        }
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)
                        .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                    .listStyle(.plain)
                }

            case .error(let error):
                ErrorView(error: error) {
                    Task { await viewModel.fetchSavedCityWeather() }
                }
            }

            Spacer()
        }
        .padding(.horizontal)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            if !isPreview {
                Task { await viewModel.fetchSavedCityWeather() }
            }
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack {
            Text("No City Selected")
                .font(.poppins(.semiBold, 30))

            Text("Please Search For A City")
                .font(.poppins(.semiBold, 15))
        }
        .foregroundStyle(Color.labelPrimary)
    }
}

private struct LoadedStateView: View {
    let city: City

    var body: some View {
        VStack {
            WeatherConditionIcon(url: city.currentWeather?.condition.iconUrl)

            HStack {
                Text(city.name)
                    .font(.poppins(.semiBold, 30))
                    .multilineTextAlignment(.center)

                Image(systemName: "location.fill")
                    .font(.system(size: 21))
            }

            Text(city.currentWeather?.temperature.formatted(.measurement(width: .narrow)) ?? "-")
                .font(.poppins(.medium, 70))
                .padding(.bottom, 36)

            ForecastDetailsView(weather: city.currentWeather)
        }
    }
}

private struct WeatherConditionIcon: View {
    let url: URL?
    let size: CGFloat

    init(url: URL?, size: CGFloat = 128) {
        self.url = url
        self.size = size
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.labelPrimary)
            case .success(let image):
                image.resizable()
            default:
                ProgressView()
            }
        }
        .frame(width: size, height: size)
    }
}

private struct ForecastDetailsView: View {
    let weather: Weather?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)

            HStack(spacing: 56) {
                VStack {
                    Text("Humidity")
                        .font(.poppins(.medium, 12))
                        .foregroundColor(.labelSecondary)

                    Text(weather != nil ? "\(weather!.humidity)%" : "-")
                        .font(.poppins(.medium, 15))
                        .foregroundStyle(.labelSecondaryDarker)
                }

                VStack {
                    Text("UV")
                        .font(.poppins(.medium, 12))
                        .foregroundColor(.labelSecondary)

                    Text(weather != nil ? "\(weather!.uvIndex.formatted(.number))" : "-")
                        .font(.poppins(.medium, 15))
                        .foregroundStyle(.labelSecondaryDarker)
                }

                VStack {
                    Text("Feels Like")
                        .font(.poppins(.medium, 12))
                        .foregroundColor(.labelSecondary)

                    Text(weather?.feelsLikeTemperature.formatted(.measurement(width: .narrow)) ?? "-")
                        .font(.poppins(.medium, 15))
                        .foregroundStyle(.labelSecondaryDarker)
                }
            }
            .padding()
        }
        .fixedSize()
    }
}

private struct CitySearchResultView: View {
    let city: City
    let onTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)

            HStack {
                VStack(alignment: .leading) {
                    Text(city.name)
                        .font(.poppins(.semiBold, 20))
                        .foregroundStyle(.labelPrimary)

                    Text(city.currentWeather?.temperature.formatted(.measurement(width: .narrow)) ?? "")
                        .font(.poppins(.medium, 60))
                        .foregroundStyle(.labelPrimary)
                }

                Spacer()

                WeatherConditionIcon(url: city.currentWeather?.condition.iconUrl, size: 64)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 31)
        }
        .fixedSize(horizontal: false, vertical: true)
        .onTapGesture { onTap() }
    }
}

#Preview {
    let city = City(
        id: 1,
        name: "Chicago",
        currentWeather: Weather(
            temperature: Measurement(value: 37.5, unit: .celsius),
            feelsLikeTemperature: Measurement(value: 44.87, unit: .celsius),
            condition: Weather.Condition(
                text: "Cloudy",
                iconUrl: URL(string: "https://cdn.weatherapi.com/weather/64x64/day/116.png")!
            ),
            humidity: 25,
            uvIndex: 17.87
        )
    )

    HomeView(viewModel: HomeView.ViewModel(
        weatherService: DIContainer.preview.services.weatherService,
        state: .loaded(city)
    )).environment(\.isPreview, true)
}
