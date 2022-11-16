Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5215762CB19
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Nov 2022 21:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiKPUgV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Nov 2022 15:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbiKPUgI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Nov 2022 15:36:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9972063B9D;
        Wed, 16 Nov 2022 12:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37C9861F84;
        Wed, 16 Nov 2022 20:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A26CC433C1;
        Wed, 16 Nov 2022 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668630957;
        bh=9aplWxONrjhJUoupnxQ9rYWVmk9y/BaAQ5G14j3nVaY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hx+ebO+ptkDm2dGfqiqOMZlNDaMZ7L80fJ1VE2TjDBLSyr917MsBhIWaX+U3Hv08t
         1K7IbYMOhsBrkLIPxMzo13M7Hjhg8eyiiuXRu4oALpyw2e9Cxuu2xXty9MvXnnqyaM
         PjDiDbDsvuAn84W7puICmbAHbuBN/GfT2aImyTWwEAnt1LkawUFqE9njCWkzXiPBtu
         xjLozl40cE0bXR/7ya4U884FnxMeLc1RVOWkSOobeAyOTuRs2REz8ega4tr3Q0pJQ5
         +F3i3Fb1jo01yPOd9r6TkdRcNQSI/MFJsGXzI6c3YXT+M90InmIPQh2CViXEWY2aI6
         jn0fwWNOX4cQQ==
Date:   Wed, 16 Nov 2022 12:35:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Neal Gompa <ngompa13@gmail.com>
Cc:     Paul Crowley <paulcrowley@google.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 00/18] btrfs: add fscrypt integration
Message-ID: <Y3VJq6YDqrO7w70F@sol.localdomain>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
 <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
 <CAEg-Je96DB34Dj9_-DtgEHaiLf+omXoZTnK71Wv2f6bcWjE0yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEg-Je96DB34Dj9_-DtgEHaiLf+omXoZTnK71Wv2f6bcWjE0yQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 16, 2022 at 03:08:26PM -0500, Neal Gompa wrote:
> On Thu, Nov 3, 2022 at 3:54 PM Paul Crowley <paulcrowley@google.com> wrote:
> >
> > Thank you for creating this! I'm told the design document [1] no
> > longer reflects the current proposal in these patches. If that's so I
> > think it's worth bringing the design document up to date so we can
> > review the cryptography. Thanks!
> >
> > [1] https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit
> 
> So this might be my ignorance here, but when I look at the patch set,
> I don't really see any significant mathematics or cryptographic work
> going on here. This seems to be primarily just interacting with the
> fscrypt stuff that exists in the kernel already.
> 
> Could you please clarify what you mean here?

There absolutely is significant cryptographic work going on here.  There needs
to be a new way to choose keys and IVs for file contents blocks, as the existing
ways are not appropriate for btrfs.  That is the main difficulty we are having.
One idea is the one which this patchset is intended to implement.  Other ideas
that have been brought up involve deriving per-extent keys, using per-block IVs,
or using authenticated encryption (or some combination of these).  These ideas
would be better cryptographically then the one that this patchset actually
implements, so it needs to be properly documented why they've been ruled out.
(Or maybe they haven't really been ruled out -- I'm not sure they have.)

And as I've mentioned, if we do go with the current proposal, which results in
some IV reuse, it needs to be decided whether we should try to ameliorate that
by hashing part of the IV with a secret key, like IV_INO_LBLK_32 does.

Another area where new cryptographic design is needed is the encryption of the
fsverity metadata.  ext4 and f2fs get encryption of the fsverity metadata "for
free" since they store it past EOF, but btrfs doesn't.

Anyway, I tried to get Paul's feedback on this patchset, but he
(understandingly) didn't want to dig through random mailing list discussions,
which don't really have all the information anyway.

I think updating the design document to fully reflect the current proposal and
the detailed reasoning behind it would be super helpful to get everyone on the
right page and to make sure the right design is being chosen.

- Eric
