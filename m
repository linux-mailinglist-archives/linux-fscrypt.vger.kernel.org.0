Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3088E64750E
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Dec 2022 18:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLHRly (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Dec 2022 12:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiLHRlw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Dec 2022 12:41:52 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE18A56C2
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Dec 2022 09:41:49 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so5422272pjp.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Dec 2022 09:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Epi0wvoArwdi93QgOlOJRom7wYA62WnSexI8WZ5n4Kc=;
        b=N+6Aj206qvb7iNXVdFQBPg6dnnVNI4o7tNTkSe6INV7p1MkBDypskH6ph7HPR2qqjY
         KCQ6bPOZjbY0MTDlYnXLXzABESm0l2DHnVDDYQQMJeKl0zRPAsQBwj6KR1VRaOI1O5gf
         4Vi3JvR+pav++uv81Rq2FxKSxA2RLAoLZgyjxSk7CphL0/sX0B4pveNMGid5X1ml5gWU
         Dam3H+j4msCo8w7a88s1CSEY83uKMIj3TtSZSbVpcw59ErrVsAAxYcTimgn1e8Y9CI0R
         rM34D9Y2fHYVEuSJ07l2l/3pknRxqPqVwafNeiKJ2scypppjp58BNAxuUzPvn14xjGMF
         6T2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Epi0wvoArwdi93QgOlOJRom7wYA62WnSexI8WZ5n4Kc=;
        b=kb1f0LocgN9pCNJCkJY4e8ilbgdgy5I1OZl5PV5cI5XgUhs1Lib9pwSXvKRc2GNAl3
         VtQugxErP8Q6fQv/IZNHJSGYqnkpr/riX6vjriCHjg+4JzRlxQgjhh/SM+8QF0r6Ex2W
         g4cOAMy1l7yiyII0EB58uVl0h3UqjUPmsefcfJdTMdC9u7JNbUT04Zp3n/BnPI70t8ga
         ZGC4pXVtUmropClRQVvGssxrSe95VlJ2faoQSLel1IjAsOxDo9xJE8PhSTRZdNyf2Ep5
         IYF8OqHfTWc9KhtEomadbJA1YQyPZ7H3D6gMWsuxFmvB/bfib4n2cR+zJp5AtHkcEuM0
         UuBQ==
X-Gm-Message-State: ANoB5plSzLdigfnnXcLtIILpn88f5vwI81kKXr0IuAbEf0t3Y53GSP4E
        9sRnXURKyuultlamuuyQTFhfOHV4uu2qUjIQNrC7
X-Google-Smtp-Source: AA0mqf77gpQVrYnOfWw3zdor+Q9b7Q2VDfHXiSgWE1uUCovE3iY2apN7bXxoa9t+H9Tct88fbwCVN8p9mCZ+UQGODpA=
X-Received: by 2002:a17:902:9892:b0:186:c3b2:56d1 with SMTP id
 s18-20020a170902989200b00186c3b256d1mr79125339plp.15.1670521309385; Thu, 08
 Dec 2022 09:41:49 -0800 (PST)
MIME-Version: 1.0
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 8 Dec 2022 12:41:38 -0500
Message-ID: <CAHC9VhTtdYsX5+j-j7sis_dzCOTtrv_=EvU35KRBg+x0gA5p+A@mail.gmail.com>
Subject: Re: [PATCH] fsverity: mark builtin signatures as deprecated
To:     bluca@debian.org
Cc:     ebiggers@kernel.org, jsorensen@meta.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        victorhsieh@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 08 Dec 2022 10:43:01 +0000, Luca Boccassi wrote:
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
>
> In essence, I very strongly object to marking this as deprecated. It is
> entirely ok if at Google you want to move everything out of the kernel,
> you know your use case best so if that works better for you that's
> absolutely fine (and thus your other patch looks good to me), but I
> don't think it should be deprecated for everybody else too.

To add some more background on the IPE LSM, it has gone through
several rounds of review on the LSM list and the developers working on
it are in the process of readying it for the next review cycle.

-- 
paul-moore.com
