Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6D342FCC6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Oct 2021 22:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbhJOUNa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Oct 2021 16:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231983AbhJOUNa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Oct 2021 16:13:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 978ED60F48;
        Fri, 15 Oct 2021 20:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634328683;
        bh=YV58xuGEMPAJRnfXW0+uR8zK5dzxQXDeUcMl4PHCdVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=alsnPvU5ETi4f/emqb+tG8JG349Ms5sKj8g4PsjAbM4Kk7qqmvqvRUaA9e6bGfV4s
         HWW7oQzaYjcefb5ZpzxV5TA7PpqWLRmKDA10y4BUh6WiBgal07/SQONMxA/hCC7f/q
         AAa0YXLAUgsD19LGOBqmVS7/j4ZwIhHzzT8AmvKJP2TApyiaCKN0qhQps7c+ez2wpM
         a7VjpP5j9RDXHFlmG7XAiqkbSUSz3MdRys6YdvDK4rd/m4kG0d6mVye1VB74LGoxyf
         gQCqBDQ3T201P1f7MbIAs20UpsYtmkqssZmDhwpg9rfwJJnqHnE+enZAdkaNjfsmO8
         9MMBCCNcWxw3A==
Date:   Fri, 15 Oct 2021 13:11:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Deven Bowers <deven.desai@linux.microsoft.com>
Cc:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, tytso@mit.edu, paul@paul-moore.com,
        eparis@redhat.com, jmorris@namei.org, serge@hallyn.com,
        jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
Message-ID: <YWngaVdvMyWBlITZ@gmail.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
 <YWcyYBuNppjrVOe2@gmail.com>
 <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Oct 15, 2021 at 12:25:53PM -0700, Deven Bowers wrote:
> 
> On 10/13/2021 12:24 PM, Eric Biggers wrote:
> > On Wed, Oct 13, 2021 at 12:06:31PM -0700, deven.desai@linux.microsoft.com wrote:
> > > From: Fan Wu <wufan@linux.microsoft.com>
> > > 
> > > Add security_inode_setsecurity to fsverity signature verification.
> > > This can let LSMs save the signature data and digest hashes provided
> > > by fsverity.
> > Can you elaborate on why LSMs need this information?
> 
> The proposed LSM (IPE) of this series will be the only one to need
> this information at the  moment. IPE’s goal is to have provide
> trust-based access control. Trust and Integrity are tied together,
> as you cannot prove trust without proving integrity.

I think you mean authenticity, not integrity?

Also how does this differ from IMA?  I know that IMA doesn't support fs-verity
file hashes, but that could be changed.  Why not extend IMA to cover your use
case(s)?

> IPE needs the digest information to be able to compare a digest
> provided by the policy author, against the digest calculated by
> fsverity to make a decision on whether that specific file, represented
> by the digest is authorized for the actions specified in the policy.
> 
> A more concrete example, if an IPE policy author writes:
> 
>     op=EXECUTE fsverity_digest=<HexDigest > action=DENY
> 
> IPE takes the digest provided by this security hook, stores it
> in IPE's security blob on the inode. If this file is later
> executed, IPE compares the digest stored in the LSM blob,
> provided by this hook, against <HexDigest> in the policy, if
> it matches, it denies the access, performing a revocation
> of that file.

Do you have a better example?  This one is pretty useless since one can get
around it just by executing a file that doesn't have fs-verity enabled.

> This brings me to your next comment:
> 
> > The digest isn't meaningful without knowing the hash algorithm it uses.
> It's available here, but you aren't passing it to this function.
> 
> The digest is meaningful without the algorithm in this case.

No, it's not.

Digests are meaningless without knowing what algorithm they were created with.

If your security policy is something like "Trust the file with digest $foo" and
multiple hash algorithms are possible, then the alorithm intended to be used
needs to be explicitly specified.  Otherwise any algorithm with the same length
digest will be accepted.  That's a fatal flaw if any of these algorithms is
cryptographically broken or was never intended to be a cryptographic algorithm
in the first place (e.g., a non-cryptographic checksum).

Cryptosystems always need to specify the crypto algorithm(s) used; the adversary
must not be allowed to choose the algorithms.

I'm not sure how these patches can be taken seriously when they're getting this
sort of thing wrong.

> > > +					FS_VERITY_SIGNATURE_SEC_NAME,
> > > +					signature, sig_size, 0);
> > This is only for fs-verity built-in signatures which aren't the only way to do
> > signatures with fs-verity.  Are you sure this is what you're looking for?
> 
> Could you elaborate on the other signature types that can be used
> with fs-verity? I’m 99% sure this is what I’m looking for as this
> is a signature validated in the kernel against the fs-verity keyring
> as part of the “fsverity enable” utility.
> 
> It's important that the signature is validated in the kernel, as
> userspace is considered untrusted until the signature is validated
> for this case.
> 
> > Can you elaborate on your use case for fs-verity built-in signatures,
> Sure, signatures, like digests, also provide a way to prove integrity,
> and the trust component comes from the validation against the keyring,
> as opposed to a fixed value in IPE’s policy. The use case for fs-verity
> built-in signatures is that we have a rw ext4 filesystem that has some
> executable files, and we want to have a execution policy (through IPE)
> that only _trusted_ executables can run. Perf is important here, hence
> fs-verity.

Most users of fs-verity built-in signatures have actually been enforcing their
security policy in userspace, by checking whether specific files have the
fs-verity bit set or not.  Such users could just store and verify signatures in
userspace instead, without any kernel involvement.  So that's what I've been
recommending (with limited success, unfortunately).

If you really do need in-kernel signature verification, then that may be a
legitimate use case for the fs-verity built-in signatures, although I do wonder
why you aren't using IMA and its signature mechanism instead.

- Eric
