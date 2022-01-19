Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5DA4931EE
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jan 2022 01:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiASAjr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Jan 2022 19:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiASAjq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Jan 2022 19:39:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B001EC061574;
        Tue, 18 Jan 2022 16:39:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A3DD614CE;
        Wed, 19 Jan 2022 00:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9F1C340E0;
        Wed, 19 Jan 2022 00:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642552785;
        bh=rlNJ3O+wBaQqAhYetNswbsESAgyvWjhZQPvJIQXyZHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pFmSHxaan3THvA8LMLq/j+6MWtW7A9dgqpWgVlprDoW4EuqlYUuv0bbaV91nuVMbc
         LNU1UvAOnF3yJPZZUR5/YxtLytQQNCxVUBbHodwdoCIyRpXna19488vqDEJkBcY8lF
         V5YIXwTMWVZwhY12XWB3yIZ4gagahUp1x3gnxqt8bM9dgb2irXM6Ngajsj1mBsaYOB
         azqE+cv0ENgI+FyTF9yIOAXkTJTmsvkW5yoENNYkoTKbODibf4pUHJVIuHJ61qY3P7
         eBvy7Sheh6fGjzaSc+v0t5aVA5harnXCJdwdjXmHOWbraohTKGc16MtAG1vw6wKYnn
         paO0KW6U91BOA==
Date:   Tue, 18 Jan 2022 16:39:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Vitaly Chikunov <vt@altlinux.org>, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Message-ID: <Yedd0CKCHSq1ugFk@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-5-zohar@linux.ibm.com>
 <YalDvGjq0inMFKln@sol.localdomain>
 <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
 <YdYrw4eiQPryOMkZ@gmail.com>
 <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
 <YdtOhsv/A5dqlApY@sol.localdomain>
 <20220115053101.36xoy2bc7ypozo6l@altlinux.org>
 <YeJn7hxLEfdVrUQT@sol.localdomain>
 <bc803a35d914dde65640428d2b29cc6e89d176d4.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc803a35d914dde65640428d2b29cc6e89d176d4.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 16, 2022 at 12:01:28PM -0500, Mimi Zohar wrote:
> On Fri, 2022-01-14 at 22:21 -0800, Eric Biggers wrote:
> > On Sat, Jan 15, 2022 at 08:31:01AM +0300, Vitaly Chikunov wrote:
> > > Eric,
> > > 
> > > On Sun, Jan 09, 2022 at 01:07:18PM -0800, Eric Biggers wrote:
> > > > On Sun, Jan 09, 2022 at 11:45:37PM +0300, Vitaly Chikunov wrote:
> > > > > On Wed, Jan 05, 2022 at 03:37:39PM -0800, Eric Biggers wrote:
> > > > > > On Fri, Dec 31, 2021 at 10:35:00AM -0500, Mimi Zohar wrote:
> > > > > > > On Thu, 2021-12-02 at 14:07 -0800, Eric Biggers wrote:
> > > > > > > > On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
> > > > > > > > >  	case IMA_VERITY_DIGSIG:
> > > > > > > > > -		fallthrough;
> > > > > > > > > +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > > > > > > > > +
> > > > > > > > > +		/*
> > > > > > > > > +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
> > > > > > > > > +		 * and the fs-verity file digest, not directly on the
> > > > > > > > > +		 * fs-verity file digest.  Both digests should probably be
> > > > > > > > > +		 * included in the IMA measurement list, but for now this
> > > > > > > > > +		 * digest is only used for verifying the IMA signature.
> > > > > > > > > +		 */
> > > > > > > > > +		verity_digest[0] = IMA_VERITY_DIGSIG;
> > > > > > > > > +		memcpy(verity_digest + 1, iint->ima_hash->digest,
> > > > > > > > > +		       iint->ima_hash->length);
> > > > > > > > > +
> > > > > > > > > +		hash.hdr.algo = iint->ima_hash->algo;
> > > > > > > > > +		hash.hdr.length = iint->ima_hash->length;
> > > > > > > > 
> > > > > > > > This is still wrong because the bytes being signed don't include the hash
> > > > > > > > algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
> > > > > > > > supports SHA-512 too, and it may support other hash algorithms in the future.
> > > > > > > 
> > > > > > > IMA assumes that the file hash algorithm and the signature algorithm
> > > > > > > are the same.   If they're not the same, for whatever reason, the
> > > > > > > signature verification would simply fail.
> > > > > > > 
> > > > > > > Based on the v2 signature header 'type' field, IMA can differentiate
> > > > > > > between regular IMA file hash based signatures and fs-verity file
> > > > > > > digest based signatures.  The digest field (d-ng) in the IMA
> > > > > > > meausrement list prefixes the digest with the hash algorithm. I'm
> > > > > > > missing the reason for needing to hash fs-verity's file digest with
> > > > > > > other metadata, and sign that hash rather than fs-verity's file digest
> > > > > > > directly.
> > > > > > 
> > > > > > Because if someone signs a raw hash, then they also implicitly sign the same
> > > > > > hash value for all supported hash algorithms that produce the same length hash.
> > > > > 
> > > > > Unless there is broken hash algorithm allowing for preimage attacks this
> > > > > is irrelevant. If there is two broken algorithms allowing for collisions,
> > > > > colliding hashes could be prepared even if algo id is hashed too.
> > > > > 
> > > > 
> > > > Only one algorithm needs to be broken.  For example, SM3 has the same hash
> > > > length as SHA-256.  If SM3 support were to be added to fs-verity, and if someone
> > > > were to find a way to find an input that has a specific SM3 digest, then they
> > > > could also make it match a specific SHA-256 digest.  Someone might intend to
> > > > sign a SHA-256 digest, but if they are only signing the raw 32 bytes of the
> > > > digest, then they would also be signing the corresponding SM3 digest.  That's
> > > > why the digest that is signed *must* also include the algorithm used in the
> > > > digest (not the algorithm(s) used in the signature, which is different).
> > > 
> > > I think it will be beneficial if we pass hash algo id to the
> > > akcipher_alg::verify. In fact, ecrdsa should only be used with streebog.
> > > And perhaps, sm2 with sm3, pkcs1 with md/sha/sm3, and ecdsa with sha family
> > > hashes.
> > > 
> > 
> > I was going to reply to this thread again, but I got a bit distracted by
> > everything else being broken.  Yes, the kernel needs to be restricting which
> > hash algorithms can be used with each public key algorithm, along the lines of
> > what you said.  I asked the BoringSSL maintainers for advice, and they confirmed
> > that ECDSA just signs/verifies a raw hash, and in fact it *must* be a raw hash
> > for it to be secure.  This is a design flaw in ECDSA, which was fixed in newer
> > algorithms such as EdDSA and SM2 as those have a hash built-in to the signature
> > scheme.  To mitigate it, the allowed hash algorithms must be restricted; in the
> > case of ECDSA, that means to the SHA family (preferably excluding SHA-1).
> > 
> > akcipher_alg::verify doesn't actually know which hash algorithm is used, except
> > in the case of rsa-pkcs1pad where it is built into the name of the algorithm.
> > So it can't check the hash algorithm.  I believe it needs to happen in
> > public_key_verify_signature() (and I'm working on a patch for that).
> > 
> > Now, SM2 is different from ECDSA and ECRDSA in that it uses the modern design
> > that includes the hash into the signature algorithm.  This means that it must be
> > used to sign/verify *data*, not a hash.  (Well, you can sign/verify a hash, but
> > SM2 will hash it again internally.)  Currently, public_key_verify_signature()
> > allows SM2 to be used to sign/verify a hash, skipping the SM2 internal hash, and
> > IMA uses this.  This is broken and must be removed, since it isn't actually the
> > SM2 algorithm as specified anymore, but rather some homebrew thing with unknown
> > security properties. (Well, I'm not confident about SM2, but homebrew is worse.)
> > 
> > Adding fs-verity support to IMA also complicates things, as doing it naively
> > would introduce an ambiguity about what is signed.  Naively, the *data* that is
> > signed (considering the hash as part of the signature algorithm) would be either
> > the whole file, in the case of traditional IMA, or the fsverity_descriptor
> > struct, in the case of IMA with fs-verity.  However, a file could have contents
> > which match an fsverity_descriptor struct; that would create an ambiguity.
> > 
> > Assuming that it needs to be allowed that the same key can sign files for both
> > traditional and fs-verity hashing, solving this problem will require a second
> > hash.
> 
> The IMA fs-verity policy rule could require specifying the hash
> algorithm.  If it would require specifying a particular key as well,
> would hashing the hash then not be needed?

If both of those were true, and if the key was never reused for other purposes
(either for other hash algorithms or for full file hashes), that would be fine.
Obviously, the IMA policy is trusted in this context, since it's what tells the
kernel to verify signatures in the first place.

But, I could see users getting this wrong and reusing keys.

> 
> > The easiest way to do this would be sign/verify the following struct:
> > 	struct ima_file_id {
> > 		u8 is_fsverity;
> > 		u8 hash_algorithm;
> > 		u8 hash[];
> > 	};
> > 
> 
> The v2 version of this patch introduces the "ima_tbs_hash" structure,
> which is more generic, since it uses the IMA xattr record type.  Other
> than that, I don't see a difference.
> 
> > This would be the *data* that is signed/verified -- meaning that it would be
> > hashed again as part of the signature algorithm (whether that hash is built-in
> > to the signature algorithm, as is the case for modern algorithms, or handled by
> > the caller as is the case for legacy algorithms).
> 
> There seems to be an inconsistency, here, with what you said above,
> "... ECDSA just signs/verifies a raw hash, and in fact it *must* be a
> raw hash for it to be secure."

There isn't an inconsistency.  ECDSA is among the algorithms where the caller is
expected to handle the hash.

It is confusing dealing with all these different signature algorithms.  I think
the right way to think about this is in terms of what *data* is being
signed/verified.  Currently the data is the full file contents.  I think it
needs to be made into an annotated hash, e.g. the struct I gave.

public_key_verify_signature() also needs to be fixed to support both types of
signature algorithms (caller-provided hash and internal hash) in a logical way.
Originally it only supported caller-provided hashes, but then SM2 support was
added and now it is super broken.

> > Note that both traditional
> > and fs-verity hashes would need to use this same method for it to be secure; the
> > kernel must not accept signatures using the old method at the same time.
> 
> The v2 version of this patch set signed the hash of a hash just for fs-
> verity signatures.  Adding the equivalent support for regular file
> hashes will require the version in the IMA signature_v2_hdr to be
> incremented.  If the version is incremented now, both signatures
> versions should then be able to co-exist.

That seems like a good thing, unless you want users to be responsible for only
ever signing full file hashes *or* fs-verity file hashes with each key.  That
seems like something that users will get wrong.

- Eric
