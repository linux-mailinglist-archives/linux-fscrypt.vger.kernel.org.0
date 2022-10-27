Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E382A6100E1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Oct 2022 20:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiJ0S6Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Oct 2022 14:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbiJ0S6Y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Oct 2022 14:58:24 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B7B1EEEC
        for <linux-fscrypt@vger.kernel.org>; Thu, 27 Oct 2022 11:58:21 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id hh9so1892239qtb.13
        for <linux-fscrypt@vger.kernel.org>; Thu, 27 Oct 2022 11:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=enc8IrGpVjXGNTcKz9NxXiwj8ah68/uzbqH61bvPW30=;
        b=T2O/UqT9b2lz5tGyVKo3w7qSdvlSrNFQ37SWI2uZf0Nn4+uPmE9YdNtiJPcnQSKinL
         B+eqU34CGQmU9wle9SLzksOFAmckb66lWvuozE7KgX+n9kcb/Ub7DRCrODUmlcQYK39F
         06hV4YwV43E0Nruyr0qfriRMkV9nvTunLOmD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=enc8IrGpVjXGNTcKz9NxXiwj8ah68/uzbqH61bvPW30=;
        b=B7plbQNllT8/IZs/xoA34CPY+Hpa2Wpxk/mOsKiZuCowrS20YFx7NuNv6VUvi6Iyo+
         enhpOTVvlkZwNry+SS9PVtZXrsMb6RBXb+gKSGTL7Ml6CETNHmurcCrBHW6CWiOwS7p6
         SbVCiFodfHxHGYa8tAw5nKnT5dklVSC8U+lpjZbY0YskktEczdBpi8nwlT5QGjgTK4SB
         nHYfoQlkhc/SgBWDGrjdUYdg+DjhlRdhtEdN0NDANrhc4+mul1ufmPM/hzVtjdNkprQy
         cw+GLZMkXf+2ewHMleot3gFhKOqzrenDvWPOPcghG1SBEe5eYJNXZNmB3wm2/l3xmF50
         DZYg==
X-Gm-Message-State: ACrzQf1qHYjyLWPyCpKbfh7HJ2F8xfjZC5wvY5EXv8vRJ1sEiExCstzw
        sYvrIIKIrJBdMl6Qzf8fvAy+VdRhXNupRw==
X-Google-Smtp-Source: AMsMyM4HwAq0Orzf8x2OS5Wq9U4YVALTkNfEd0KwVkSwycsMpq8f2Gc4WIH7FzC6zW6X0v64bLUNUQ==
X-Received: by 2002:ac8:5a05:0:b0:39d:8a5:356d with SMTP id n5-20020ac85a05000000b0039d08a5356dmr36684396qta.472.1666897100679;
        Thu, 27 Oct 2022 11:58:20 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id j3-20020a05620a410300b006eef13ef4c8sm1477275qko.94.2022.10.27.11.58.19
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 11:58:19 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id r3so3363588yba.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 27 Oct 2022 11:58:19 -0700 (PDT)
X-Received: by 2002:a25:5389:0:b0:6bc:f12c:5d36 with SMTP id
 h131-20020a255389000000b006bcf12c5d36mr45238400ybb.184.1666897099027; Thu, 27
 Oct 2022 11:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <Y1oPDy2mpOd91+Ii@sol.localdomain>
In-Reply-To: <Y1oPDy2mpOd91+Ii@sol.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 27 Oct 2022 11:58:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjDQiJn6YUJ18Nb=L82qsgx3LBLtQu0xANeVoc6OAzFtQ@mail.gmail.com>
Message-ID: <CAHk-=wjDQiJn6YUJ18Nb=L82qsgx3LBLtQu0xANeVoc6OAzFtQ@mail.gmail.com>
Subject: Re: [GIT PULL] fscrypt fix for 6.1-rc3
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 26, 2022 at 9:54 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Fix a memory leak that was introduced by a change that went into -rc1.

Unrelated to the patch in question, but since it made me look, I wish
code like that fscrypt_destroy_keyring() function would be much more
obvious about the whole "yes, I can validly be called multiple times"
(not exactly idempotent, but you get the idea).

Yes, it does that

        struct fscrypt_keyring *keyring = sb->s_master_keys;
        ...
        if (!keyring)
                return;
        ...
        sb->s_master_keys = NULL;

but it's all spread out so that you have to actually look for it (and
check that there's not some other early return).

Now, this would need an atomic xchg(NULL) to be actually thread-safe,
and that's not what I'm looking for - I'm just putting out the idea
that for functions that are intentionally meant to be cleanup
functions that can be called multiple times serially, we should strive
to make that more clear.

Just putting that sequence together at the very top of the function
would have helped, being one simple visually obvious pattern:

        keyring = sb->s_master_keys;
        if (!keyring)
                return;
        sb->s_master_keys = NULL;

makes it easier to see that yes, it's fine to call this sequentially.

It also, incidentally, tends to generate better code, because that
means that we're just done with 'sb' entirely after that initial
sequence and that it has better register pressure and cache patterns.

No, that code generation is not really important here, but just a sign
that this is just a good coding pattern in general - not just good for
people looking at the code, but for the compiler and hardware too.

                   Linus
