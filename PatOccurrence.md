# pat.occurrence #

Represents each occurrence of a pattern.

Properties:
  * `id`: A numerical address.
  * `pattern`: The associated pattern.
  * `prefix`: The longest prefix, i.e. the occurrence without the last symbol (which is also a pattern occurrence).
  * `suffix`: The last extension of the pattern.
  * `specific`: Occurrences that are immediately more specific (such that none of them are not more specific than other of them).  (array)
  * `general`: More general occurrences (such that none of them are not more general than other of them). (array)
  * `extensions`: Extensions of the occurrence, i.e., occurrences for which the present occurrence is the longest prefix. (array)
and for cyclic occurrences:
  * `cycle`: The _cycle model_ (i.e., the whole pattern chain that is currently repeated cyclically). Only the part of the cycle model from the current pattern is indicated.
  * `round`: The number of cycles currently performed.
Dependent property:
  * `parameter`: Usually the parameter of the last extension in the pattern. But for cyclic patterns, at the transition point between one complete cycle to the next one, the pattern associated with the occurrence is the pattern tree root, so the pattern parameter is indicated instead at the last extension of the cycle model.

The constructor:
  * for a new cyclic occurrence, construct the cycle model.
  * for a cyclic occurrence under extension, update the `cycle` property by removing the first state.
  * construct a new prefix if necessary: Occurrences that are more general than other occurrences are not explicitly represented, but if the more general occurrence needs to be extended (such that the extension is not more general than another occurrence), then the more general occurrence needs to be reconstructed.