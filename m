Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5B9632C2F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Nov 2022 19:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKUSjk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Nov 2022 13:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiKUSjj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Nov 2022 13:39:39 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18E3CEFDF
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Nov 2022 10:39:35 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id p184so9244009iof.11
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Nov 2022 10:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6pMBKkz/dz3aQqTl7mhhbAzRSuHiokJcH7elJ899uEM=;
        b=UuoIqyJyixQFs7Jf8jpiMvrizTxsSAwzcssUZKaH1drY6kbm+ANvQcNfsmg6Dl75dm
         nX9/2ISgE21p6Asc6xuBvHTqWHjmYCJrSxH+jKlxT9fLQwrRvEDY3qJa1GjwKb4Tg23P
         8i/Nax76dnJQI5UGgLhDzbV4RWCSPNfKIs0db1ImdnGEN+W9uPhMVgl4frqUzyqfeIZP
         vECTwFSh6aXaol2IFdwkk2KTL2+GFExPwJ3i+FDWBvtdV1nq0CmmNJUq7E/ed8hB0r44
         UE7ezomGCYk16YNM4F9ONHH+6kxAS8/enZHyLwEYuGATRi4htttiZHVhXnpU5gAP805T
         G2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6pMBKkz/dz3aQqTl7mhhbAzRSuHiokJcH7elJ899uEM=;
        b=gDcC7fhi5/oZrjUpQlkTQ69S1blF1enzW6JJeWVFcWdYQiDHIds19b5fPcGUEI6lpU
         hCJay6Pse3uhdtEHe8aXSuDuk7gWnkXju1o9D/PyMsJSxxU3RIu6PxroR+3ys+z01zY4
         g58w9wpjZoNSs0hTsBClYmF6JflsxdWmtR3p4sfIMF9ikdJmWEGpwbyHpai6wh1e79Xq
         TH2Hn6oZpVxsDqRUA0hjjuBZdPwWZqS6DNCBiU7E/ewZrPwYWNjam92fr6P46hSPlMM4
         CxPPsZFVund8XtXKiYfkkV3ZBJXW4UTdYMUOE8PtvoFeTYCtnjZyHIDZKOBogRJXb6Cz
         h2LA==
X-Gm-Message-State: ANoB5pnm64bnkjsEeK2Si3TVQ4m4Vhv9Hny5x3HEjK9J6ofD/9EA4k5d
        HSIM+qHKrJP9FUzITW6rY72+cfcwuefZow==
X-Google-Smtp-Source: AA0mqf7mgkRUpfMeIYsGOMnxGuuOO5ueSoGqz6a+HzTinXPm92/vpzyly1tUfn12/gMh5aR47F8sTw==
X-Received: by 2002:a02:780e:0:b0:375:ab48:de95 with SMTP id p14-20020a02780e000000b00375ab48de95mr1208395jac.14.1669055975090;
        Mon, 21 Nov 2022 10:39:35 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w184-20020a025dc1000000b00356744215f6sm4596037jaa.47.2022.11.21.10.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 10:39:34 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>
In-Reply-To: <20221114042944.1009870-1-hch@lst.de>
References: <20221114042944.1009870-1-hch@lst.de>
Subject: Re: pass a struct block_device to the blk-crypto interfaces v3
Message-Id: <166905597395.59249.16543635744813742339.b4-ty@kernel.dk>
Date:   Mon, 21 Nov 2022 11:39:33 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 14 Nov 2022 05:29:41 +0100, Christoph Hellwig wrote:
> this series switches the blk-crypto interfaces to take block_device
> arguments instead of request_queues, and with that finishes off the
> project to hide struct request_queue from file systems.
> 
> Changes since v2:
>  - update a few comments
>  - fix a whitespace error
>  - remove now unused forward declarations
>  - fix spelling errors an not precise enough wording in commit messages
>  - move a few more declarations around inside or between headers
> 
> [...]

Applied, thanks!

[1/3] blk-crypto: don't use struct request_queue for public interfaces
      commit: fce3caea0f241f5d34855c82c399d5e0e2d91f07
[2/3] blk-crypto: add a blk_crypto_config_supported_natively helper
      commit: 6715c98b6cf003f26b1b2f655393134e9d999a05
[3/3] blk-crypto: move internal only declarations to blk-crypto-internal.h
      commit: 3569788c08235c6f3e9e6ca724b2df44787ff487

Best regards,
-- 
Jens Axboe


