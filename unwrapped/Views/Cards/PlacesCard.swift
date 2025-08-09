import SwiftUI
import MapKit

struct PlacesCard: View {
    var places: [Place]

    var body: some View {
        CardFrame {
            VStack(alignment: .leading, spacing: DS.Spacing.md) {
                Text("Places & Top Spots")
                    .font(DS.Typography.headline)
                    .foregroundColor(Palette.ink)
                if let first = places.first {
                    Map(
                        initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: first.coordinate.latitude, longitude: first.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)))
                    )
                    .frame(height: 200)
                    .cornerRadius(DS.Radius.md)
                }
                VStack(alignment: .leading) {
                    ForEach(places.prefix(5)) { p in
                        Text("\(p.name) · \(p.visitCount)")
                    }
                }
                Spacer()
            }
        }
    }
}

