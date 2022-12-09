Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8353C64865A
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Dec 2022 17:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiLIQNU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Dec 2022 11:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLIQNK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Dec 2022 11:13:10 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5C926A90;
        Fri,  9 Dec 2022 08:13:09 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-12c8312131fso291643fac.4;
        Fri, 09 Dec 2022 08:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gFY1W9e4ekbWqyIP76hyzmpwflzYOcseT2pOw5ioGts=;
        b=ppQOsQzB5cHrYFUOIA9zkwszmGsUXghe3JUBfS9o3Z8lXxcHje88+B2H+PdvOonbiC
         Z5EYWl07d3SHjlmrhObxY/FcxrS9CGfPWqUV3xJj64DQjxtHWl+twTzJCg9ieePTwZkX
         aP66yK9Wk553rK6ZK4b25hivQD8YD4rISIQfEY8YiPDFDPKGb0hjfpGb/lYj7lFeyKFP
         lpJQu2D/sfzeIlRizL30EhF0T3HUw9p7xVFowdet1NQfzs63qrMOS3pPV5sIDFO/iBPv
         N5fISjYxHftJA4J2QPfcZENiEKXm8CUGqjw3nXwIKwddC4aUZ3O1U4LuZ1ijwtbYps5x
         JO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFY1W9e4ekbWqyIP76hyzmpwflzYOcseT2pOw5ioGts=;
        b=m+9jWAdetpVWn5Oq3FMk+oqhgxVgWdN43lJs9fFEg1/wleVzpuqmo243jql8E1ELfM
         Gj3n+6ModCzfwgOECsTqFy86lb0MbFNBhqP4+46KQLo946dkHpVPV4SgwgG2fR+Cc3tT
         FlXDQAuGzYSF1t+zZ2QvfPBsOJitNacfUZDAfkG0fWZ4y/O2NZS3STJ942OdElKCwJrb
         VLFVKWSLEIO6ineIZj9F6WUQb5aL7O7PJJm0Bnnpi3XQsiJWIJlfL0GncU5PaOO8MRg/
         WdkJXGrixfwewdA2XCE7g1q91JKc8XflgiFNZjT96CurHojuo0ek/zNFqnNIb/i8jRKu
         7cFQ==
X-Gm-Message-State: ANoB5pkWomU1FNfciS8GHRADO7ZiglQlruYJgWUfJVNP/c939xZEJTjh
        lt+yySSpzDOGJvguv4COxEgNxn/zxJLhSPj+HEM=
X-Google-Smtp-Source: AA0mqf7md76CbIvE5CZgYvyN3yFG9ko30sLUCK0WzA39CGIVtpzpvd6YDHB0wQW8HAr0zJs6dNXtbyjQmM368nF8CUQ=
X-Received: by 2002:a05:6870:6689:b0:144:dffd:8302 with SMTP id
 ge9-20020a056870668900b00144dffd8302mr3757743oab.146.1670602388565; Fri, 09
 Dec 2022 08:13:08 -0800 (PST)
MIME-Version: 1.0
References: <20221106224841.279231-1-ebiggers@kernel.org> <Y4+ua2XftbAYd8xq@mit.edu>
In-Reply-To: <Y4+ua2XftbAYd8xq@mit.edu>
From:   harshad shirwadkar <harshadshirwadkar@gmail.com>
Date:   Fri, 9 Dec 2022 08:12:56 -0800
Message-ID: <CAD+ocbznGVej2myzU+3edpw0a_EXcVRjLAU=KS1ymXxbaEaz=Q@mail.gmail.com>
Subject: Re: [PATCH 0/7] ext4 fast-commit fixes
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 6 Dec 2022 at 13:04, Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Sun, Nov 06, 2022 at 02:48:34PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@kernel.org
> >
> > This series fixes several bugs in the fast-commit feature.
> >
> > Patch 6 may be the most controversial patch of this series, since it
> > would make old kernels unable to replay fast-commit journals created by
> > new kernels.  I'd appreciate any thoughts on whether that's okay.  I can
> > drop that patch if needed.
>
> Mumble.  Normally, it's something we would avoid, since there aren't
> that many users using fast commit, since it's not enabled by default.
> And given that the off-by-one errors are bugs, an it's a question of
> old kernels requiring a pretty buggy layout, the question is whether
> it's worth it to do an explicit version / feature flag and support
> both for some period of time.
>
> I'm inclined to say no, and just let things slide, and instead make
> sure that e2fsck can handle both the old and the new format, and let
> that handle the fast commit replay if necessary.
>
> Harshad, what do you think?
I agree. Making kernel replay backward compatible would complicate the
replay code without adding that much value (since there aren't that
many users and fast commit isn't enabled by default). So, having the
ability in e2fsck to do replays should suffice in this case.

- Harshad
>
>                                                 - Ted
