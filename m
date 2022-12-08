Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60E647785
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Dec 2022 21:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLHUzm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Dec 2022 15:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHUzk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Dec 2022 15:55:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F85989AF6;
        Thu,  8 Dec 2022 12:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9347B8261B;
        Thu,  8 Dec 2022 20:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44762C433F0;
        Thu,  8 Dec 2022 20:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670532935;
        bh=rbuH8ivUiGqEUNAE8E1MZzREUenrlcc3yHgPx3wu918=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b3riEFg9pwcCA2/bl24yKGEzPVFIY31TIBifX49pOMVNxi4yRcVO/qrZYfFD6FqZI
         yeEg/YOK8tVYivQ4DhG8zU90S/HBfVqQ6Q6E3f2EFAzuNSIQaRS7DnLSbGglZV27+/
         xtSXDIhRE5hNnMWA+4dzYFn/J788Sl/AecJvpIh4wojkqI2fwiHo5WuUHt5oWyJG5P
         L5EPtz3Z7V8EskcDOPe8U1y+xrPJXtv5L4i9NtD/ferwJluJoZ9co8H9aYcuQpwE0s
         AmHflod78yvrdz1ynEXqHiljwBzSjO2SEVqWrBbM55mLL/XBamdnD5BpX3W6Zx9wB4
         iAsL13h/Y3TMw==
Date:   Thu, 8 Dec 2022 12:55:33 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>
Subject: Re: [PATCH] fsverity: mark builtin signatures as deprecated
Message-ID: <Y5JPRW+9dt28JpZ7@sol.localdomain>
References: <20221208033548.122704-1-ebiggers@kernel.org>
 <eea9b4dc9314da2de39b4181a4dac59fda8b0754.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eea9b4dc9314da2de39b4181a4dac59fda8b0754.camel@debian.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 08, 2022 at 10:43:01AM +0000, Luca Boccassi wrote:
> On Wed, 2022-12-07 at 19:35 -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > fsverity builtin signatures, at least as currently implemented, are a
> > mistake and should not be used.  They mix the authentication policy
> > between the kernel and userspace, which is not a clean design and causes
> > confusion.  For builtin signatures to actually provide any security
> > benefit, userspace still has to enforce that specific files have
> > fsverity enabled.  Since userspace needs to do this, a better design is
> > to have that same userspace code do the signature check too.
> > 
> > That allows better signature formats and algorithms to be used, avoiding
> > in-kernel parsing of the notoriously bad PKCS#7 format.  It is also
> > needed anyway when different keys need to be trusted for different
> > files, or when it's desired to use fsverity for integrity-only or
> > auditing on some files and for authenticity on other files.  Basically,
> > the builtin signatures don't work for any nontrivial use case.
> > 
> > (IMA appraisal is another alternative.  It goes in the opposite
> > direction -- the full policy is moved into the kernel.)
> > 
> > For these reasons, the master branch of AOSP no longer uses builtin
> > signatures.  It still uses fsverity for some files, but signatures are
> > verified in userspace when needed.
> > 
> > None of the public uses of builtin signatures outside Android seem to
> > have gotten going, either.  Support for builtin signatures was added to
> > RPM.  However, https://fedoraproject.org/wiki/Changes/FsVerityRPM was
> > subsequently rejected from Fedora and seems to have been abandoned.
> > There is also https://github.com/ostreedev/ostree/pull/2269, which was
> > never merged.  Neither proposal mentioned a plan to set
> > fs.verity.require_signatures=1 and enforce that files have fs-verity
> > enabled -- so, they would have had no security benefit on their own.
> > 
> > I'd be glad to hear about any other users of builtin signatures that may
> > exist, and help with the details of what should be used instead.
> > 
> > Anyway, the feature can't simply be removed, due to the need to maintain
> > backwards compatibility.  But let's at least make it clear that it's
> > deprecated.  Update the documentation accordingly, and rename the
> > kconfig option to CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG.  Also remove
> > the kconfig option from the s390 defconfigs, as it's unneeded there.
> 
> Hi,
> 
> Thanks for starting this discussion, it's an interesting topic.
> 
> At MSFT we use fsverity in production, with signatures enforced by the
> kernel (and policy enforced by the IPE LSM). It's just too easy to fool
> userspace with well-timed swaps and who knows what else. This is not
> any different from dm-verity from our POV, it complements it. I very
> much want the kernel to be in charge of verification and validation, at
> the time of use.

Well, IPE is not upstream, and it duplicates functionality that already exists
upstream (IMA appraisal).  So from an upstream perspective it doesn't really
matter currently.  That's interesting that you've already deployed IPE in
production anyway.  To re-iterate my question at
https://lore.kernel.org/r/YqKGcdM3t5gjqBpq@sol.localdomain which was ignored,
can you elaborate on why IPE should exist when IMA appraisal already exists (and
already supports fsverity), and why IPE uses the fsverity builtin signatures?
And are you sure that X.509 and PKCS#7 should be used in a new system?  These
days, if you go through any sort of crypto or security review, you will be told
not to use those formats since they are overly complex and prone to bugs.

- Eric
