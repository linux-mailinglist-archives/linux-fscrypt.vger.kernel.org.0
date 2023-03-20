Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758E96C144C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Mar 2023 15:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjCTOFO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 10:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjCTOEu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 10:04:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E27435AC
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Mar 2023 07:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679321043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/PSB6Nsz7o8LHZj2T/kpSDL6QgnL3s1fRiM33zhd6LU=;
        b=gz+CZQ7dDhL0vN/dImW9kwcJRBgNTYWBv56hLYG2qWVAifZ0P0ug7eQKZ+VvfdIZtPACZ9
        IjUj5B5vu4FBqwQXLw6RtFHIXbJFYv3QsVt8jO7bkjpP0hsd2dBKrB5pJEcWrvyVmo66t9
        /HygvyRQID2WZzJJGjekbCorIgzQil8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-13WpOOuyMcmQMmme1Lv5Cw-1; Mon, 20 Mar 2023 10:04:01 -0400
X-MC-Unique: 13WpOOuyMcmQMmme1Lv5Cw-1
Received: by mail-pg1-f200.google.com with SMTP id t76-20020a635f4f000000b0050bea7a0577so2635231pgb.12
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Mar 2023 07:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679321036;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PSB6Nsz7o8LHZj2T/kpSDL6QgnL3s1fRiM33zhd6LU=;
        b=cOV2BviIKhvsSR+OW5BPnOQ5licuBlQihRdSFwFfxRP6hSHXvAwsD5oIph1nd4yf/6
         nnDUQR1PbmeDE4racQOUIP+qNWNDbiVVpL58rlmMNKEzLXNUfgoh9/QJ66QNCce0D0l2
         yczzJbuY9tPfnMqYa8T0TGExAuM9u0WDYqW8iHuGOeO1PbNUkuTptbQ5ZugnvJ72KNCG
         qvAzm2rCLNmVAdac7wh1gn7YOOZznFg0VZqhC7/iR6NzmIgiWKKY2zZmtytPDmgAZ4Pr
         tcOXBCh965n3jIzmxDrdWcNPWmPwpZwFj5btJ6e9S2udsdnL6MU9SKUfTavWe21e/bfL
         9Pvg==
X-Gm-Message-State: AO0yUKVVpVvBxNwMahzuzCnrsL3A5OiaiNMfM3tA8xMf2fmLOhKf5lWe
        vtpi1+mtaJh8ZxJtG0KgZ80fC+eWkXnqbN1OGNkY51dUf8jAm245MrteSSyHHRhDkzJHQqF5K87
        k9FQmO2kkoxXjN6kBOulY/T+/8g==
X-Received: by 2002:a05:6a21:78a0:b0:cc:d891:b2b1 with SMTP id bf32-20020a056a2178a000b000ccd891b2b1mr24225877pzc.35.1679321035890;
        Mon, 20 Mar 2023 07:03:55 -0700 (PDT)
X-Google-Smtp-Source: AK7set/7e8M6ZokI1Ye9mDyLHcYZBN4Vsk5V84q+FdXMxIosct0x/PnqqcGN5j8bnunPzRCguDt7sQ==
X-Received: by 2002:a05:6a21:78a0:b0:cc:d891:b2b1 with SMTP id bf32-20020a056a2178a000b000ccd891b2b1mr24225840pzc.35.1679321035455;
        Mon, 20 Mar 2023 07:03:55 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i20-20020aa79094000000b005abbfa874d9sm5946971pfa.88.2023.03.20.07.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:03:54 -0700 (PDT)
Date:   Mon, 20 Mar 2023 22:03:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/3] xfstests: make fscrypt-crypt-util self-tests work
 with OpenSSL 3.0
Message-ID: <20230320140350.w4gg32a4f2kpv62s@zlang-mailbox>
References: <20230319193847.106872-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319193847.106872-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Mar 19, 2023 at 12:38:44PM -0700, Eric Biggers wrote:
> This series makes the algorithm self-tests in fscrypt-crypt-util (which
> are not compiled by default) work with OpenSSL 3.0.  Previously they
> only worked with OpenSSL 1.1.
> 
> Eric Biggers (3):
>   fscrypt-crypt-util: fix HKDF self-test with latest OpenSSL
>   fscrypt-crypt-util: use OpenSSL EVP API for AES self-tests
>   fscrypt-crypt-util: fix XTS self-test with latest OpenSSL
> 
>  src/fscrypt-crypt-util.c | 46 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 9 deletions(-)
> 
> -- 

I'm not familiar with fscrypt changes, but from the commit log of 3 patches,
this patchset looks good to me. If there's not more review points from
linux-fscrypt@, I'll merge this patchset.

Just one tiny review point, I'd like to keep using same comment format, especially
in same source file. As src/fscrypt-crypt-util.c generally use "/* ... */", so
I'll change your "//..." to "/* ... */" when I merge it, if you don't mind.

Thanks,
Zorro

> 2.40.0
> 

