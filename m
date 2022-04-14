Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21689500935
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Apr 2022 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241633AbiDNJGD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Apr 2022 05:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241573AbiDNJFw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Apr 2022 05:05:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18726F499;
        Thu, 14 Apr 2022 02:02:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so5087470pjb.1;
        Thu, 14 Apr 2022 02:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ra8sTloUhXrmQm6bDrnx3eRSudlOMsdx1X1zRIJ8nFk=;
        b=FhrlUytDOlF0CxAxPTrE6p/rx0p5uA5J6wgm30E0eDY1WavB4UZTGNsw9uM9hUInbO
         f0vD8wTnMZcslJqwic02nI9iBvZ81T6lcNmeX8jZD/odHAh0OldNqPobldvQXMcyqJge
         HuAeGCIaGNedSKM21FxRJjNkevTlrfuZG1USE6J1hIvYhQJfmHF6ZgPjIpCM3YTNqxId
         PMgMGp4s/p2tmNotC1RcqbPXuZdtbZjhcu8OjVmDmIYvHzYle5eNYOSeONOkm+nQjaeG
         FObfdgiuXRE9DL6vTPK8XxOSrYY+Ocfc/HmknsjUdFBKDjXDtcLNg6K98fUv0lIvL/HM
         SfEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ra8sTloUhXrmQm6bDrnx3eRSudlOMsdx1X1zRIJ8nFk=;
        b=vExQuE3dEfnEaMI9qeKW7SCCwgrbFAVaIjnQiV0qkZLGWwAMAl/ax2Hfh0RSiKjT5D
         n4O2M/In+jmpgMSk2N1aGVxI30iAumQdb9ayAWol+DSW+bLXWBkxM8KdoPzxXuknxC4C
         shexvg/yCl9gXHf5EN/3+ulJAl7qjDgLSc7EjyuFvMfwqZ2HwUA+V0pGNHNj6VtuiKPh
         W+/5zNRPtYc/9/LXBdfcH3POCiQszsKZmQpL36OKFDpWqeHPy/b6t09MnKsVc4pXqLv/
         v4tLfJfTyZCXh45mzJg7l+qXjQKuWljgJVF6Brsx3UqEwyZC9suKuqoQIrRtAe8jNZKQ
         aDTA==
X-Gm-Message-State: AOAM532AGODDfml4FLHnO0mhk5tdwOQ82rO1OBwmGIyodpN2b25hXjxs
        42so4RgNnPRQhpE9Cd+AgGTczKXyufk=
X-Google-Smtp-Source: ABdhPJwr40sEsLOk5YCn60R34atpqifTi4nyr1kpxZYl6eVwTkqw5+CeTGWSIyL+BhTmylfSMsisCw==
X-Received: by 2002:a17:902:d5cd:b0:156:6263:bbc7 with SMTP id g13-20020a170902d5cd00b001566263bbc7mr47940778plh.160.1649926952143;
        Thu, 14 Apr 2022 02:02:32 -0700 (PDT)
Received: from localhost ([2406:7400:63:d4bc:afbf:fe26:9814:5d0e])
        by smtp.gmail.com with ESMTPSA id y131-20020a626489000000b00505a8f36965sm1483776pfb.184.2022.04.14.02.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 02:02:31 -0700 (PDT)
Date:   Thu, 14 Apr 2022 14:32:27 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [xfstests PATCH v2] common/encrypt: use a sub-keyring within the
 session keyring
Message-ID: <20220414090227.ksdfs4kai6dt4k3v@riteshh-domain>
References: <20220414071932.166090-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414071932.166090-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/04/14 12:19AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Make the encryption tests create and use a named keyring "xfstests" in
> the session keyring that the tests happen to be running under, rather
> than replace the session keyring using 'keyctl new_session'.
> Unfortunately, the latter doesn't work when the session keyring is owned
> by a non-root user, which (depending on the Linux distro) can happen if
> xfstests is run in a sudo "session" rather than in a real root session.
>
> This isn't a great solution, as the lifetime of the keyring will no
> longer be tied to the tests as it should be, but it should work.  The
> alternative would be the weird hack of making the 'check' script
> re-execute itself using something like 'keyctl session - $0 $@'.
>
> Reported-by: Ritesh Harjani <ritesh.list@gmail.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Thanks Eric for the quick resolution.
This fixes the mentioned issue for me. I was able to run "-g encrypt" xfstests
on my qemu session. Once all the test completed, I confirmed the keyring
named xfstests was created.

<results>
SECTION       -- ext4_4k
=========================
Ran: ext4/024 generic/395 generic/396 generic/397 generic/398 generic/399 generic/419 generic/421 generic/429 generic/435 generic/440 generic/548 generic/549 generic/550 generic/576 generic/580 generic/581 generic/582 generic/583 generic/584 generic/592 generic/593 generic/595 generic/602 generic/613 generic/621
Not run: generic/549 generic/550 generic/576 generic/583 generic/584
Passed all 26 tests

<keyring details>
qemu-> sudo keyctl show
Session Keyring
 253043311 --alswrv   1000  1000  keyring: _ses
 390003206 ---lswrv   1000 65534   \_ keyring: _uid.1000
 235062718 --alswrv      0     0   \_ keyring: xfstests
 241276015 --als--v      0     0       \_ fscrypt-provisioning: 0000111122223333
 373669133 --als--v      0     0       \_ fscrypt-provisioning: 69b2f6edeee720cce0577937eb8a6751

-ritesh
