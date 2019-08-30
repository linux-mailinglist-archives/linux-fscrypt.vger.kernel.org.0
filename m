Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECBBA3201
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Aug 2019 10:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfH3ITG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Aug 2019 04:19:06 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59590 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfH3ITG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Aug 2019 04:19:06 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i3c7R-0004CV-Eo; Fri, 30 Aug 2019 18:18:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2019 18:18:52 +1000
Date:   Fri, 30 Aug 2019 18:18:52 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        dm-devel@redhat.com, linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v13 0/6] crypto: switch to crypto API for ESSIV generation
Message-ID: <20190830081852.GA8033@gondor.apana.org.au>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 19, 2019 at 05:17:32PM +0300, Ard Biesheuvel wrote:
> This series creates an ESSIV template that produces a skcipher or AEAD
> transform based on a tuple of the form '<skcipher>,<shash>' (or '<aead>,<shash>'
> for the AEAD case). It exposes the encapsulated sync or async skcipher/aead by
> passing through all operations, while using the cipher/shash pair to transform
> the input IV into an ESSIV output IV.
> 
> Changes since v12:
> - don't use a per-instance shash but only record the cra_driver_name of the
>   shash when instantiating the template, and allocate the shash for each
>   allocated transform instead
> - add back the dm-crypt patch -> as Milan has indicated, his preference would
>   be to queue these changes for v5.4 (with the first patch shared between the
>   cryptodev and md trees on a stable branch based on v5.3-rc1 - if needed,
>   I can provide a signed tag)
> 
> Changes since v11:
> - Avoid spawns for the ESSIV shash and cipher algos. Instead, the shash TFM is
>   allocated per-instance (which is appropriate since it is unkeyed and thus
>   stateless), and the cipher is allocated explicitly based on the parsed
>   skcipher/aead cra_name.
> 
> Changes since v10:
> - Drop patches against fscrypt and dm-crypt - these will be routed via the
>   respective maintainer trees during the next cycle
> - Fix error handling when parsing the cipher name from the skcipher cra_name
> - Use existing ivsize temporary instead of retrieving it again
> - Expose cra_name via module alias (#4)
> 
> Changes since v9:
> - Fix cipher_api parsing bug that was introduced by dropping the cipher name
>   parsing patch in v9 (#3). Thanks to Milan for finding it.
> - Fix a couple of instances where the old essiv(x,y,z) format was used in
>   comments instead of the essiv(x,z) format we adopted in v9
> 
> Changes since v8:
> - Remove 'cipher' argument from essiv() template, and instead, parse the
>   cra_name of the skcipher to obtain the cipher. This is slightly cleaner
>   than what dm-crypt currently does, since we can get the cra_name from the
>   spawn, and we don't have to actually allocate the TFM. Since this implies
>   that dm-crypt does not need to provide the cipher, we can drop the parsing
>   code from it entirely (assuming the eboiv patch I sent out recently is
>   applied first) (patch #7)
> - Restrict the essiv() AEAD instantiation to AEADs whose cra_name starts with
>   'authenc('
> - Rebase onto cryptodev/master
> - Drop dm-crypt to reorder/refactor cipher name parsing, since it was wrong
>   and it is no longer needed.
> - Drop Milan's R-b since the code has changed
> - Fix bug in accelerated arm64 implementation.
> 
> Changes since v7:
> - rebase onto cryptodev/master
> - drop change to ivsize in #2
> - add Milan's R-b's
> 
> Changes since v6:
> - make CRYPTO_ESSIV user selectable so we can opt out of selecting it even
>   if FS_ENCRYPTION (which cannot be built as a module) is enabled
> - move a comment along with the code it referred to (#3), not that this change
>   and removing some redundant braces makes the diff look totally different
> - add Milan's R-b to #3 and #4
> 
> Changes since v5:
> - drop redundant #includes and drop some unneeded braces (#2)
> - add test case for essiv(authenc(hmac(sha256),cbc(aes)),aes,sha256)
> - make ESSIV driver deal with assoc data that is described by more than two
>   scatterlist entries - this only happens when the extended tests are being
>   performed, so don't optimize for it
> - clarify that both fscrypt and dm-crypt only use ESSIV in special cases (#7)
> 
> Changes since v4:
> - make the ESSIV template IV size equal the IV size of the encapsulated
>   cipher - defining it as 8 bytes was needlessly restrictive, and also
>   complicated the code for no reason
> - add a missing kfree() spotted by Smatch
> - add additional algo length name checks when constructing the essiv()
>   cipher name
> - reinstate the 'essiv' IV generation implementation in dm-crypt, but
>   make its generation function identical to plain64le (and drop the other
>   methods)
> - fix a bug in the arm64 CE/NEON code
> - simplify the arm64 code by reusing more of the existing CBC implementation
>   (patch #6 is new to this series and was added for this reason)
> 
> Changes since v3:
> - address various review comments from Eric on patch #1
> - use Kconfig's 'imply' instead of 'select' to permit CRYPTO_ESSIV to be
>   enabled as a module or disabled entirely even if fscrypt is compiled in (#2)
> - fix an issue in the AEAD encrypt path caused by the IV being clobbered by
>   the inner skcipher before the hmac was being calculated
> 
> Changes since v2:
> - fixed a couple of bugs that snuck in after I'd done the bulk of my
>   testing
> - some cosmetic tweaks to the ESSIV template skcipher setkey function
>   to align it with the aead one
> - add a test case for essiv(cbc(aes),aes,sha256)
> - add an accelerated implementation for arm64 that combines the IV
>   derivation and the actual en/decryption in a single asm routine
> 
> Code can be found here
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=essiv-v11
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: dm-devel@redhat.com
> Cc: linux-fscrypt@vger.kernel.org
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>
> Cc: Milan Broz <gmazyland@gmail.com>
> 
> Ard Biesheuvel (6):
>   crypto: essiv - create wrapper template for ESSIV generation
>   crypto: essiv - add tests for essiv in cbc(aes)+sha256 mode
>   crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
>   crypto: arm64/aes - implement accelerated ESSIV/CBC mode
>   md: dm-crypt: switch to ESSIV crypto API template
>   md: dm-crypt: omit parsing of the encapsulated cipher
> 
>  arch/arm64/crypto/aes-glue.c  | 206 ++++--
>  arch/arm64/crypto/aes-modes.S |  28 +
>  crypto/Kconfig                |  28 +
>  crypto/Makefile               |   1 +
>  crypto/essiv.c                | 663 ++++++++++++++++++++
>  crypto/tcrypt.c               |   9 +
>  crypto/testmgr.c              |  14 +
>  crypto/testmgr.h              | 497 +++++++++++++++
>  drivers/md/Kconfig            |   1 +
>  drivers/md/dm-crypt.c         | 271 ++------
>  10 files changed, 1448 insertions(+), 270 deletions(-)
>  create mode 100644 crypto/essiv.c

Patches 2-4 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
