Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01A3648AAC
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Dec 2022 23:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiLIWRq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Dec 2022 17:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLIWRV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Dec 2022 17:17:21 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE3696F49D;
        Fri,  9 Dec 2022 14:17:19 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 7DF0F20B6C40; Fri,  9 Dec 2022 14:17:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7DF0F20B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1670624239;
        bh=e2p3lV/i3GYggsKEuSqhvyowXaG6c8Gams0z3H4jil0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QQVD5MN/Bc4ZIZqfQdAh9+57E5pB8OGU4pOmwEw7LuQykQ8ooFVM0VSHz4CG2MRfn
         ZVjurNF0kAR9+C8Egnd96+QaTTnJ2CpJCfUjfSEF4gMxbzk5LgLZaEh8taX/uWXy4L
         diC/Vdgj9F+HJ12ACN7d0NrY7lZhnd2q6MxEbkU0=
Date:   Fri, 9 Dec 2022 14:17:19 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Luca Boccassi <bluca@debian.org>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>
Subject: Re: [PATCH] fsverity: mark builtin signatures as deprecated
Message-ID: <20221209221719.GA3055@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221208033548.122704-1-ebiggers@kernel.org>
 <eea9b4dc9314da2de39b4181a4dac59fda8b0754.camel@debian.org>
 <Y5JPRW+9dt28JpZ7@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5JPRW+9dt28JpZ7@sol.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 08, 2022 at 12:55:33PM -0800, Eric Biggers wrote:
> On Thu, Dec 08, 2022 at 10:43:01AM +0000, Luca Boccassi wrote:
> > On Wed, 2022-12-07 at 19:35 -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > fsverity builtin signatures, at least as currently implemented, are a
> > > mistake and should not be used.  They mix the authentication policy
> > > between the kernel and userspace, which is not a clean design and causes
> > > confusion.  For builtin signatures to actually provide any security
> > > benefit, userspace still has to enforce that specific files have
> > > fsverity enabled.  Since userspace needs to do this, a better design is
> > > to have that same userspace code do the signature check too.
> > > 
> > > That allows better signature formats and algorithms to be used, avoiding
> > > in-kernel parsing of the notoriously bad PKCS#7 format.  It is also
> > > needed anyway when different keys need to be trusted for different
> > > files, or when it's desired to use fsverity for integrity-only or
> > > auditing on some files and for authenticity on other files.  Basically,
> > > the builtin signatures don't work for any nontrivial use case.
> > > 
> > > (IMA appraisal is another alternative.  It goes in the opposite
> > > direction -- the full policy is moved into the kernel.)
> > > 
> > > For these reasons, the master branch of AOSP no longer uses builtin
> > > signatures.  It still uses fsverity for some files, but signatures are
> > > verified in userspace when needed.
> > > 
> > > None of the public uses of builtin signatures outside Android seem to
> > > have gotten going, either.  Support for builtin signatures was added to
> > > RPM.  However, https://fedoraproject.org/wiki/Changes/FsVerityRPM was
> > > subsequently rejected from Fedora and seems to have been abandoned.
> > > There is also https://github.com/ostreedev/ostree/pull/2269, which was
> > > never merged.  Neither proposal mentioned a plan to set
> > > fs.verity.require_signatures=1 and enforce that files have fs-verity
> > > enabled -- so, they would have had no security benefit on their own.
> > > 
> > > I'd be glad to hear about any other users of builtin signatures that may
> > > exist, and help with the details of what should be used instead.
> > > 
> > > Anyway, the feature can't simply be removed, due to the need to maintain
> > > backwards compatibility.  But let's at least make it clear that it's
> > > deprecated.  Update the documentation accordingly, and rename the
> > > kconfig option to CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG.  Also remove
> > > the kconfig option from the s390 defconfigs, as it's unneeded there.
> > 
> > Hi,
> > 
> > Thanks for starting this discussion, it's an interesting topic.
> > 
> > At MSFT we use fsverity in production, with signatures enforced by the
> > kernel (and policy enforced by the IPE LSM). It's just too easy to fool
> > userspace with well-timed swaps and who knows what else. This is not
> > any different from dm-verity from our POV, it complements it. I very
> > much want the kernel to be in charge of verification and validation, at
> > the time of use.
> 
> Well, IPE is not upstream, and it duplicates functionality that already exists
> upstream (IMA appraisal).  So from an upstream perspective it doesn't really
> matter currently.  That's interesting that you've already deployed IPE in
> production anyway.  To re-iterate my question at
> https://lore.kernel.org/r/YqKGcdM3t5gjqBpq@sol.localdomain which was ignored,
> can you elaborate on why IPE should exist when IMA appraisal already exists (and
> already supports fsverity), and why IPE uses the fsverity builtin signatures?
> And are you sure that X.509 and PKCS#7 should be used in a new system?  These
> days, if you go through any sort of crypto or security review, you will be told
> not to use those formats since they are overly complex and prone to bugs.
> 
> - Eric

IPE is just a different approach, like btrfs and ext4,
for a small subset of IMA's features: appraisal.

IMA is a fantastic solution for a whole lot of scenarios that IPE will not
cover, now or ever. In fact, in production, we use IMA (both measurement
and appraisal) and IPE side-by-side. They're not mutually exclusive.
 
IPE's approach is to really focus on the policy enforcement side, delegating
the authenticity (or even just integrity) claim to other subsystems. It does
this by enforcing an opaqueness between these integrations with other subsystems,
drawing a clear line between the mechanism of the authenticity claim,
and the enforcement of that claim against authorized values in policy. This
allows for a variable security bar based on what mechanisms are selected to
be used in the system, and what are present in the policy. For instance, the security
bar of a system using dm-verity with signed root hashes as its primary authenticity
claim, as opposed to fs-verity will have a different security bar.

This is why IPE uses the built-in signatures: they are managed by fs-verity,
and IPE does not implement its own signature format or other method of
validating either the integrity or authenticity of a data source,
explicitly, as that would be contrary to its design philosophy.

We have also noticed many use cases for the fs-verity build-in signatures. Proposals
exist to use them[1]. Package managers were updated to use them[2]. We are
successfully using them in production. Therefore we prefer to keep the existing
build-in signatures.

[1]https://fedoraproject.org/wiki/Changes/FsVerityRPM#Enable_fs-verity_in_RPM
[2]https://github.com/rpm-software-management/rpm/issues/1121

- Fan
