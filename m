Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E575B1F78
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiIHNoE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 09:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiIHNoD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 09:44:03 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74485ED984
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 06:44:02 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id i9so6935944qka.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 06:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=5mdmjkjLC5eua+YE1s8vN2xogR3eHSAey1ZvclOUDOg=;
        b=3wpyhtuj4lMCT1dlwB69Z0It2aQl+IUfqP3waROexHHmNJ36St8Mh2wC+Kxiyhfx9X
         n05IPvJMGAIPrKkOHWYFoOBk30XSsCN1hGsUlC64ru+xGd4fn1PYPAntsFICWd6bKMUo
         QaZQoCG5vQ11zbhLnYERj6zP3sBnMU5nkdQ/GLeROtbaHfbW+NTALnjYOsa0yqtz7q9U
         qUC8zn8ZTP0UOW5oXXcYLhNLp/1oU4hesV8/fRyr2PD9KQ+5QBVqlX81aojyOtAynTG4
         Xuz8+dMNcXViG3WHzr+ZvpoTAIUNS8jC5NZxIHN67l6GAgbwhyco0Xi+WZkS0tX9qmgJ
         1HRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5mdmjkjLC5eua+YE1s8vN2xogR3eHSAey1ZvclOUDOg=;
        b=5lhUbDnI9khXa5a/V643WW4d4T/MWN/dFzdW3AZ68gJE/fIztMG3XD/Jr19AL3GER9
         aQZJOA9Zd5zEI7KSHU8N7qQdKMYmgLTWBoSRZGtBo++3BsABXcAPGCWEs+V6uWXGQhlQ
         GoS4A8ln6LDUk1S3avVC3p3HDsbxk1YC16AsVoghxcOEJJiKngZ+NT2eKSiHzYlJGWzP
         9urzg6W7p34Ya7Jti4EkVEDlosueZ+m1OugNwppkpDjcNLLbyIr+q1zqEhviIjql+T6O
         vAfmLVsc3ORbei7F/kO1k0tu2rdOFetLxGnHPnsZ7Oal/YwYBVJ99yzIg5KbB8dknrsw
         Gq+w==
X-Gm-Message-State: ACgBeo2tZHt0rH1OKpGuRf7oOrejMlreMpiWTO5hwl9eI2sbnC+Brbhn
        0cDns3oX3M7+aevkJobNqB7z5Bifm1MmaA==
X-Google-Smtp-Source: AA6agR6vXc46JYpyyb+Vdt7i3ejJviljHg3DIaysM6Fyt/t7VbxWdfhOIpPKoE+1IxCUaI5puIK77w==
X-Received: by 2002:a05:620a:29d1:b0:6bb:6b8a:e767 with SMTP id s17-20020a05620a29d100b006bb6b8ae767mr6017231qkp.767.1662644641403;
        Thu, 08 Sep 2022 06:44:01 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id a26-20020a05620a103a00b006aee5df383csm15770748qkk.134.2022.09.08.06.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:44:00 -0700 (PDT)
Date:   Thu, 8 Sep 2022 09:43:59 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 02/20] fscrypt: add flag allowing partially-encrypted
 directories
Message-ID: <Yxnxn/tbzRpg/aiJ@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:17PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Creating several new subvolumes out of snapshots of another subvolume,
> each for a different VM's storage, is a important usecase for btrfs.  We
> would like to give each VM a unique encryption key to use for new writes
> to its subvolume, so that secure deletion of the VM's data is as simple
> as securely deleting the key; to avoid needing multiple keys in each VM,
> we envision the initial subvolume being unencrypted. However, this means
> that the snapshot's directories would have a mix of encrypted and
> unencrypted files. During lookup with a key, both unencrypted and
> encrypted forms of the desired name must be queried.
> 
> To allow this, add another FS_CFLG to allow filesystems to opt into
> partially encrypted directories.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
