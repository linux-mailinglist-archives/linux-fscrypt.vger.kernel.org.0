Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C957B5B1F6F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 15:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiIHNmC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 09:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiIHNmA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 09:42:00 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ED7E72E3
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 06:42:00 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id k12so190696qkj.8
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 06:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=vArWBSM/nIYB9WM/+V9vXBEe1u7QlNsucCYETEZMIl4=;
        b=3H0LWu9tBE7RU4TEBRMQZrpKn0Eogi/gbLKru1GmfCEN/99xYNyAUUL305YbJj8wsf
         35WxKm8cPFGxuC0QJ//0olE8bF8HCaP33XJ2qePfItc8ErJI9abM26RTKSwrmGYuuLfw
         8bQ5dSM1p7yVaPhe9IBSiFdltmTrjD+7mZGhKXw7TbCEz9tZ9gPMXLxw105qzv69nhbc
         VMYMnP1PK0aNlGtYum8+tIec/7U4Fg3Bk+e5ziPJEfJHAKlo3fVGJnBWI657qluAqQHC
         BdaUl7HYH2qxrBNyEZNvryPXKRUO1eXd7ciZO0VCYd6dP05GYadoC5eioQ8Nab3wWKHQ
         4hvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=vArWBSM/nIYB9WM/+V9vXBEe1u7QlNsucCYETEZMIl4=;
        b=c7ee+jzuWKqyc4K0cK/By1pAjFijLgtv46hA+T5P5VDxtx5kYs/yeohfj124S8JzXo
         xw0nFHjb1eFuGZXX0CXcIf4QQuPZbV83zuFCfM1cHpCcL6nsOk1U31sKfkJH0BTz7O6z
         Y+/Ix8DUsHyx9IOOKOyJXsjXdObx7P6TK4CV7LkiO/CD0NX7hVau1la/FBW2T16mIVso
         6ej+iCpJm31P1uIhvOWSrl0qg+M96X+g4jko8tc4FNB2XUBxcA89SiLyyFx6MHgvozeP
         9oWOzyMRsWkwGaL72M93k1LRf7bvYCJsTdVZKCaQJTDSPr7zqDwW+rCARELGVsEHbD+T
         bbfA==
X-Gm-Message-State: ACgBeo2j00NTPSOYO7Mpu1ssIZOBg++oSvJetfhMJeLVbELQXd0mpNBt
        ux1yJwLhbSgD0rfyqAxQUs+g5w==
X-Google-Smtp-Source: AA6agR6y99PKgF7Urb6nyu+ug+2KCgGfJlr6dZEGrmX50hsIjUYl1d2Gp9FsS4XVZldoWQ7MNhLO/Q==
X-Received: by 2002:a05:620a:57b:b0:6bb:f708:589f with SMTP id p27-20020a05620a057b00b006bbf708589fmr6699096qkp.112.1662644518990;
        Thu, 08 Sep 2022 06:41:58 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id bq38-20020a05620a46a600b006b8f4ade2c9sm17118385qkb.19.2022.09.08.06.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:41:58 -0700 (PDT)
Date:   Thu, 8 Sep 2022 09:41:52 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 01/20] fscrypt: expose fscrypt_nokey_name
Message-ID: <YxnxIOd1HCpxUUuC@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <b77f881449e67d61862ec28d3863fd9036978e8e.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b77f881449e67d61862ec28d3863fd9036978e8e.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:16PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> btrfs stores its data structures, including filenames in directories, in
> its own buffer implementation, struct extent_buffer, composed of
> several non-contiguous pages. We could copy filenames into a
> temporary buffer and use fscrypt_match_name() against that buffer, such
> extensive memcpying would be expensive. Instead, exposing
> fscrypt_nokey_name as in this change allows btrfs to recapitulate
> fscrypt_match_name() using methods on struct extent_buffer instead of
> dealing with a raw byte array.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
