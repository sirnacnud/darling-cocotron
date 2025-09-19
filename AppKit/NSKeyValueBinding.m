/*
 This file is part of Darling.

 Copyright (C) 2019 Lubos Dolezel

 Darling is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Darling is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Darling.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <AppKit/NSKeyValueBinding.h>

NSBindingInfoKey NSObservedObjectKey = @"NSObservedObject";
NSBindingInfoKey NSObservedKeyPathKey = @"NSObservedKeyPath";
NSBindingInfoKey NSOptionsKey = @"NSOptions";

NSBindingName NSAnimateBinding = @"animate";
NSBindingName NSContentArrayBinding = @"contentArray";
NSBindingName NSContentBinding = @"content";
NSBindingName NSContentObjectBinding = @"contentObject";
NSBindingName NSContentObjectsBinding = @"contentObjects";
NSBindingName NSContentSetBinding = @"contentSet";
NSBindingName NSContentValuesBinding = @"contentValues";
NSBindingName NSDoubleClickTargetBinding = @"doubleClickTarget";
NSBindingName NSEnabledBinding = @"enabled";
NSBindingName NSFontBoldBinding = @"fontBold";
NSBindingName NSFontItalicBinding = @"fontItalic";
NSBindingName NSHiddenBinding = @"hidden";
NSBindingName NSImageBinding = @"image";
NSBindingOption NSInsertsNullPlaceholderBindingOption =
        @"NSInsertsNullPlaceholder";
NSBindingName NSSelectedIndexBinding = @"selectedIndex";
NSBindingName NSSelectedObjectBinding = @"selectedObject";
NSBindingName NSSelectedObjectsBinding = @"selectedObjects";
NSBindingName NSSelectedTagBinding = @"selectedTag";
NSBindingName NSSelectedValueBinding = @"selectedValue";
NSBindingName NSSelectionIndexesBinding = @"selectionIndexes";
NSBindingName NSTitleBinding = @"title";
NSBindingOption NSValidatesImmediatelyBindingOption = @"NSValidatesImmediately";
NSBindingOption NSNotApplicablePlaceholderBindingOption =
        @"NSNotApplicablePlaceholder";
NSBindingName NSValueBinding = @"value";
NSBindingName NSVisibleBinding = @"visible";
NSBindingName NSToolTipBinding = @"toolTip";
NSBindingName NSEditableBinding = @"editable";

NSBindingOption NSNullPlaceholderBindingOption = @"NSNullPlaceholder";
NSBindingOption NSNoSelectionPlaceholderBindingOption =
        @"NSNoSelectionPlaceholder";
NSBindingOption NSMultipleValuesPlaceholderBindingOption =
        @"NSMultipleValuesPlaceholder";
NSBindingOption NSPredicateFormatBindingOption = @"NSPredicateFormat";
NSBindingOption NSCreatesSortDescriptorBindingOption =
        @"NSCreatesSortDescriptors";
NSBindingOption NSRaisesForNotApplicableKeysBindingOption =
        @"NSRaisesForNotApplicableKeys";
NSBindingOption NSAllowsEditingMultipleValuesSelectionBindingOption =
        @"NSAllowsEditingMultipleValuesSelection";
NSBindingOption NSValueTransformerNameBindingOption = @"NSValueTransformerName";
NSBindingOption NSValueTransformerBindingOption = @"NSValueTransformerBinding";
NSBindingOption NSConditionallySetsEnabledBindingOption =
        @"NSConditionallySetsEnabled";
NSBindingOption NSConditionallySetsEditableBindingOption =
        @"NSConditionallySetsEditable";
NSBindingOption NSContinuouslyUpdatesValueBindingOption =
        @"NSContinuouslyUpdatesValue";
NSBindingOption NSDisplayPatternBindingOption = @"NSDisplayPattern";

// TODO: actually implement this stuff
@implementation NSObject (NSKeyValueBindingCreation)

- (NSArray<NSString *> *) exposedBindings
{
        return @[];
}

@end
