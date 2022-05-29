import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('investment category correctly converts to JSON', () {
    const categoryOne = InvestmentCategory(name: "Bank");
    var json = categoryOne.toJson();
    Map<String, Object?> expected = {
      "_id": null,
      "name": "Bank",
      "label": null
    };
    expect(json, expected);

    const categoryTwo =
        InvestmentCategory(name: "Depot", id: 51, label: "Invested");
    json = categoryTwo.toJson();
    expected = {"_id": 51, "name": "Depot", "label": "Invested"};
    expect(json, expected);
  });

  test('investment category converts from JSON', () {
    Map<String, Object?> categoryOneJSON = {
      "_id": 1,
      "name": "Bank",
      "label": null
    };
    const expectOne = InvestmentCategory(name: "Bank", id: 1);
    expect(
        expectOne.equals(InvestmentCategory.fromJson(categoryOneJSON)), true);

    Map<String, Object?> categoryTwoJSON = {
      "_id": null,
      "name": "Bank",
      "label": null
    };
    const expectTwo = InvestmentCategory(name: "Bank");
    expect(
        expectTwo.equals(InvestmentCategory.fromJson(categoryTwoJSON)), true);

    Map<String, Object?> categoryThreeJSON = {
      "_id": null,
      "name": "Bank",
      "label": "Saved"
    };
    const expectThree = InvestmentCategory(name: "Bank", label: "Saved");
    expect(expectThree.equals(InvestmentCategory.fromJson(categoryThreeJSON)),
        true);
  });

  test('investment category copy method', () {
    const category = InvestmentCategory(name: "Cash");

    var copyOne = category.copy(name: "Bank", id: 1);
    Map<String, Object?> expectOneJSON = {
      "_id": 1,
      "name": "Bank",
      "label": null
    };
    expect(copyOne.toJson(), expectOneJSON);

    var copyTwo = category.copy(label: "Invested");
    Map<String, Object?> expectTwoJSON = {
      "_id": null,
      "name": "Cash",
      "label": "Invested"
    };
    expect(copyTwo.toJson(), expectTwoJSON);

    var copyThree = copyTwo.copy(name: "Depot");
    Map<String, Object?> expectThreeJSON = {
      "_id": null,
      "name": "Depot",
      "label": "Invested"
    };
    expect(copyThree.toJson(), expectThreeJSON);
  });

  test('investment snapshot converts to JSON', () {
    var snapshotOne = InvestmentSnapshot(
        amount: 125.12,
        date: DateTime.fromMicrosecondsSinceEpoch(1640901600000000),
        categoryId: 5);
    Map<String, Object?> expectedOne = {
      "_id": null,
      "amount": 125.12,
      "date": DateTime.fromMicrosecondsSinceEpoch(1640901600000000)
          .toIso8601String(),
      "category_id": 5
    };
    expect(snapshotOne.toJson(), expectedOne);

    var snapshotTwo = InvestmentSnapshot(
        id: 25,
        amount: 1225.12,
        date: DateTime.fromMicrosecondsSinceEpoch(1640901600000000),
        categoryId: 5);
    Map<String, Object?> expectedTwo = {
      "_id": 25,
      "amount": 1225.12,
      "date": DateTime.fromMicrosecondsSinceEpoch(1640901600000000)
          .toIso8601String(),
      "category_id": 5
    };
    expect(snapshotTwo.toJson(), expectedTwo);
  });

  test('investment snapshot converts from JSON', () {
    Map<String, Object?> snapshotOneJSON = {
      "_id": 25,
      "amount": 1225.12,
      "date": DateTime.fromMicrosecondsSinceEpoch(1640901600000000)
          .toIso8601String(),
      "category_id": 5
    };
    var expectOne = InvestmentSnapshot(
        id: 25,
        amount: 1225.12,
        date: DateTime.fromMicrosecondsSinceEpoch(1640901600000000),
        categoryId: 5);
    expect(
        expectOne.equals(InvestmentSnapshot.fromJson(snapshotOneJSON)), true);

    Map<String, Object?> snapshotTwoJSON = {
      "_id": null,
      "amount": 125.12,
      "date": DateTime.fromMicrosecondsSinceEpoch(1640901600000000)
          .toIso8601String(),
      "category_id": 5
    };
    var expectTwo = InvestmentSnapshot(
        amount: 125.12,
        date: DateTime.fromMicrosecondsSinceEpoch(1640901600000000),
        categoryId: 5);
    expect(
        expectTwo.equals(InvestmentSnapshot.fromJson(snapshotTwoJSON)), true);
  });

  test('investment snapshot copy method', () {
    var snapshotOne = InvestmentSnapshot(
        id: 25,
        amount: 1225.12,
        date: DateTime.fromMicrosecondsSinceEpoch(1640901600000000),
        categoryId: 5);

    var copyOne = snapshotOne.copy(amount: 150);
    Map<String, Object?> expectOneJSON = {
      "_id": 25,
      "amount": 150,
      "date": DateTime.fromMicrosecondsSinceEpoch(1640901600000000)
          .toIso8601String(),
      "category_id": 5
    };
    expect(copyOne.toJson(), expectOneJSON);

    var copyTwo = snapshotOne.copy(categoryId: 10);
    Map<String, Object?> expectTwoJSON = {
      "_id": 25,
      "amount": 1225.12,
      "date": DateTime.fromMicrosecondsSinceEpoch(1640901600000000)
          .toIso8601String(),
      "category_id": 10
    };
    expect(copyTwo.toJson(), expectTwoJSON);

    var copyThree = copyTwo.copy(id: 1, amount: 1500);
    Map<String, Object?> expectThreeJSON = {
      "_id": 1,
      "amount": 1500,
      "date": DateTime.fromMicrosecondsSinceEpoch(1640901600000000)
          .toIso8601String(),
      "category_id": 10
    };
    expect(copyThree.toJson(), expectThreeJSON);
  });
}
