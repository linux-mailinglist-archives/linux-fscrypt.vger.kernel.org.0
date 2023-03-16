Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EC26BD403
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Mar 2023 16:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjCPPi6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Mar 2023 11:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjCPPik (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Mar 2023 11:38:40 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D35B78A7
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Mar 2023 08:36:55 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q6so975902iot.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Mar 2023 08:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678980956;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbqCSyzQ2Vc+jOdl+z6pC6351AAeMd3EjtD4NdIeOsM=;
        b=ZKJm1OkRdU7+ulP5R+L16WoW86AjyshwdfPWmzyY369cvbGOBr0ljZdSOwgZgq8jUJ
         XC2epD2SQpjZkNhcFLPUdG6qxXVaLPJjoo+rLG0yhrczb+FH3fw8gAfeccoB7T2HM3IG
         ROygfCN6aoeRo1y7yUGtveEL+rSteP6RXWCVyhQD6BdwSykI/0VG5lYsK8088ayhxyym
         0kQAuWnV+B03/rF1eENiy+sJ0JAlrr2Nbpa1/wWkN+k9Zd+WHz9rW6FC3WnUzP2Lvx11
         I55HoZk54TpCJXbCjA1iQl4kVT6oU0nwyUSrCddo9w5G9ipBFxQP9q+Qq8tmeLrLXUCq
         vI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980956;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbqCSyzQ2Vc+jOdl+z6pC6351AAeMd3EjtD4NdIeOsM=;
        b=ftAsZowNP2ctjxRgMf/XcYsjc1FWdnp2j59DhIBuVLhHgdTGeLYwkIZxufmHdIEyer
         bM6QF4aUN1xzpfTW7jXeMauhjgXj5tXE64GwEEXw31pGP85cXDvbvBt4b/5ECvPL50Sk
         JrqbgmQh12/pNDDFN+K/A4VCh/ec/xm74Y9vL4R+sNU7l2xuI9P7U3TOBc5JADF0fgUL
         Qzxh0eiXBAL+MSZS9h2b7BkxiIcLxrTYA1/1wJF/aG6q8WDR5fGWKcsZ3PI02WDVRYWZ
         5YZlUmpd4MxTcU4xDc1Z8E2PEpn722KgZKFGw7gFHu16oTBctoPvFTTeWtNNdRYdHiwq
         rnGg==
X-Gm-Message-State: AO0yUKWgAy8iOoJBTT4WRJ97TFNsw7QQUpXA6FFrTCAwtXaVruJncpRV
        fSNj9TYvMEWdkM7wuSS16LAX2Q==
X-Google-Smtp-Source: AK7set8GnW5ByrPgZRuHB6Q6wFJgPvrgcHqe5wCLkLBo57phwL0hWWCrMSfD9fe1rIR99Gq23Bl1mg==
X-Received: by 2002:a05:6602:2c07:b0:74e:5fba:d5df with SMTP id w7-20020a0566022c0700b0074e5fbad5dfmr2370748iov.0.1678980955955;
        Thu, 16 Mar 2023 08:35:55 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t8-20020a056638204800b004050d92f6d4sm726970jaj.50.2023.03.16.08.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:35:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
In-Reply-To: <20230315183907.53675-1-ebiggers@kernel.org>
References: <20230315183907.53675-1-ebiggers@kernel.org>
Subject: Re: [PATCH v3 0/6] Fix blk-crypto keyslot race condition
Message-Id: <167898095529.31557.16126359951385476698.b4-ty@kernel.dk>
Date:   Thu, 16 Mar 2023 09:35:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On Wed, 15 Mar 2023 11:39:01 -0700, Eric Biggers wrote:
> This series fixes a race condition in blk-crypto keyslot management and
> makes some related cleanups.  It replaces
> "[PATCH] blk-crypto: make blk_crypto_evict_key() always try to evict"
> (https://lore.kernel.org/r/20230226203816.207449-1-ebiggers@kernel.org),
> which was a simpler fix but didn't fix the keyslot reference counting to
> work as expected.
> 
> [...]

Applied, thanks!

[1/6] blk-mq: release crypto keyslot before reporting I/O complete
      (no commit info)
[2/6] blk-crypto: make blk_crypto_evict_key() return void
      (no commit info)
[3/6] blk-crypto: make blk_crypto_evict_key() more robust
      (no commit info)
[4/6] blk-crypto: remove blk_crypto_insert_cloned_request()
      (no commit info)
[5/6] blk-mq: return actual keyslot error in blk_insert_cloned_request()
      (no commit info)
[6/6] blk-crypto: drop the NULL check from blk_crypto_put_keyslot()
      (no commit info)

Best regards,
-- 
Jens Axboe



