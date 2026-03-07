# Refactoring UI (Adam Wathan & Steve Schoger) — Teaching Content

## Visual Hierarchy

### Deep (first exposure)

Every interface has too much information competing for the user's attention. The central argument of Refactoring UI is that most design problems are hierarchy problems: not that elements are ugly, but that everything looks equally important, so nothing feels important. Visual hierarchy is the technique of using size, weight, color, and spacing to create a clear order of importance — guiding the user's eye from the most critical information to the least without them having to think about where to look.

Size and font weight are the primary tools. A page title at 14px regular weight looks the same as body text, so the user has to read content to figure out what is a heading and what is a paragraph. Bump the title to 24px semi-bold and the hierarchy is immediately clear. But Wathan and Schoger warn against relying solely on font size — you cannot keep making things bigger forever. Instead, use a combination: primary content gets large size and bold weight, secondary content gets normal size and regular weight, and tertiary content (timestamps, metadata, helper text) gets smaller size and lighter color. Color should communicate information, not decorate. A grey timestamp tells the user "this is less important than the black headline" without being invisible. A blue link tells the user "this is actionable." If everything is blue, nothing is actionable. The authors recommend establishing a constrained palette — two or three text colors, a primary action color, and a danger color — and using it consistently so that color always carries meaning.

Spacing is the most underused hierarchy tool. Elements that are close together are perceived as related (the Gestalt principle of proximity). A form label 4px above its input clearly belongs to that input. A form label equidistant between two inputs is ambiguous. The authors advocate for generous whitespace between unrelated sections and tight spacing within related groups. This creates visual grouping without needing lines, boxes, or borders — which add clutter. Shadows and depth follow the same principle: a card with a subtle shadow lifts off the page and signals "I am a distinct object." But if every element has a shadow, the depth loses its meaning. Use depth sparingly to draw attention to elevated elements like modals, dropdowns, and primary action cards.

Without deliberate visual hierarchy, interfaces feel overwhelming even when they contain exactly the right information. Users have to work harder to parse the page, make more mistakes, and leave faster. The fix is rarely adding more visual elements (borders, icons, colors) — it is removing visual noise and establishing clear rank through the tools you already have: size, weight, color, spacing, and selective depth.

### Refresher (subsequent exposure)

Visual hierarchy uses size, weight, color, and spacing to establish a clear order of importance so that users do not have to work to parse the interface. Limit text to two or three levels of prominence, use spacing to group related elements, treat color as information (not decoration), and apply depth sparingly to elevate only the elements that need attention.

### Socratic Questions

- You are reviewing a dashboard where every metric is displayed in the same font size, weight, and color. The product manager says users are confused about which numbers matter most. Without adding any new elements, how would you use size, weight, and color to create a clear hierarchy among these metrics?
- A developer on your team adds a subtle grey border around every card, section, and input on a settings page. The page feels cluttered even though it has the same content as before. What alternative approach would create visual grouping without adding more visual elements, and why does spacing work better here?
- Your signup form has a "Create Account" primary button and a "Cancel" link. A designer makes both the same size, color, and weight. What goes wrong from a user behavior perspective, and how would you differentiate these two actions using hierarchy principles?
