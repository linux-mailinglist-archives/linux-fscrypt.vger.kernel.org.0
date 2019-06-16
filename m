Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEF8476C5
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 Jun 2019 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFPUoV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jun 2019 16:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfFPUoV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jun 2019 16:44:21 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B5DA20657;
        Sun, 16 Jun 2019 20:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560717860;
        bh=ERPegYNkzD1FcPth0R9F9JaoxJphp4IIppVtDXCAaNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZD6nfl7QbXsr+bn8m9kTTtdpdUoXBi0n15kPmSdKZAlCEOIRivM4FfR69m3zh2m18
         LPiET6joxh6wkELK/OQae09JQnGUC/78BNQoB2y1xsBTeG6YEMesv3ZOUxPiKWpNli
         0KVytrVhuGIvPn94jla5XNNePdj7jk3cHVog67/8=
Date:   Sun, 16 Jun 2019 13:44:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
Message-ID: <20190616204419.GE923@sol.localdomain>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[+Cc dm-devel and linux-fscrypt]

On Fri, Jun 14, 2019 at 10:34:01AM +0200, Ard Biesheuvel wrote:
> This series is presented as an RFC for a couple of reasons:
> - it is only build tested
> - it is unclear whether this is the right way to move away from the use of
>   bare ciphers in non-crypto code
> - we haven't really discussed whether moving away from the use of bare ciphers
>   in non-crypto code is a goal we agree on
> 
> This series creates an ESSIV shash template that takes a (cipher,hash) tuple,
> where the digest size of the hash must be a valid key length for the cipher.
> The setkey() operation takes the hash of the input key, and sets into the
> cipher as the encryption key. Digest operations accept input up to the
> block size of the cipher, and perform a single block encryption operation to
> produce the ESSIV output.
> 
> This matches what both users of ESSIV in the kernel do, and so it is proposed
> as a replacement for those, in patches #2 and #3.
> 
> As for the discussion: the code is untested, so it is presented for discussion
> only. I'd like to understand whether we agree that phasing out the bare cipher
> interface from non-crypto code is a good idea, and whether this approach is
> suitable for fscrypt and dm-crypt.
> 
> Remaining work:
> - wiring up some essiv(x,y) combinations into the testing framework. I wonder
>   if anything other than essiv(aes,sha256) makes sense.
> - testing - suggestions welcome on existing testing frameworks for dm-crypt
>   and/or fscrypt
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@google.com>
> 
> Ard Biesheuvel (3):
>   crypto: essiv - create a new shash template for IV generation
>   dm crypt: switch to essiv shash
>   fscrypt: switch to ESSIV shash
> 
>  crypto/Kconfig              |   3 +
>  crypto/Makefile             |   1 +
>  crypto/essiv.c              | 275 ++++++++++++++++++++
>  drivers/md/Kconfig          |   1 +
>  drivers/md/dm-crypt.c       | 137 ++--------
>  fs/crypto/Kconfig           |   1 +
>  fs/crypto/crypto.c          |  11 +-
>  fs/crypto/fscrypt_private.h |   4 +-
>  fs/crypto/keyinfo.c         |  64 +----
>  9 files changed, 321 insertions(+), 176 deletions(-)
>  create mode 100644 crypto/essiv.c

I agree that moving away from bare block ciphers is generally a good idea.  For
fscrypt I'm fine with moving ESSIV into the crypto API, though I'm not sure a
shash template is the best approach.  Did you also consider making it a skcipher
template so that users can do e.g. "essiv(cbc(aes),sha256,aes)"?  That would
simplify things much more on the fscrypt side, since then all the ESSIV-related
code would go away entirely except for changing the string "cbc(aes)" to
"essiv(cbc(aes),sha256,aes)".

Either way, for testing the fscrypt change, I recently added tests to xfstests
that verify the on-disk ciphertext in userspace, including for non-default modes
such as the AES-128-CBC-ESSIV in question.  So I'm not too worried about the
fscrypt encryption getting accidentally broken anymore.  If you want to run the
AES-128-CBC-ESSIV test yourself, you should be able to do it by following the
directions at
https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
and running 'kvm-xfstests -c ext4 generic/549'.

As for adding essiv to testmgr, sha256 and aes would be enough for fscrypt.
There aren't any plans to add more ESSIV settings to fscrypt, and
AES-128-CBC-ESSIV was only added in the first place because some people wanted
to use fscrypt on platforms with CBC hardware acceleration but not XTS.

- Eric
