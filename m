Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9377A7766AC
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 19:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjHIRov (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 13:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjHIRov (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 13:44:51 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C45F1703
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 10:44:50 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-63cfd68086dso514246d6.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 10:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691603089; x=1692207889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k2O6vFIa4dgKbuKR1rg6JpJF0+bZFj6QQrv1vVWDTKY=;
        b=DpTu6VopJkGebQy4Ywrb74k+WaUzmIZtNx1iTAuK7PYTFObEAiYBWmzSpFc/mpgXXA
         YIiG9s6LgLFHYOSuskHzS3dwDMF4HnXDMKXzWIuEmjj/uTC6u9b++NAAuQtbPMnzvw32
         HzzRLSvbu10KG5gx1fXGvvpOKd+8uWmDYDBu9/WuTIn6U3HIgkW37SXJM/rPq3mrPUn6
         OeoeFrwrsqh/nuiI1wVEIoP0GoDJIk/v1hwlJg/Fizq7iMFy47viJxQue+IEt51AGxUf
         ChVlyfNEMyN68A09lNFXJgP1SC1pbyD5+Tzawg9Czl/Iv8LlVM9ZUGEJlqHtTN33qEKN
         Di+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691603089; x=1692207889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2O6vFIa4dgKbuKR1rg6JpJF0+bZFj6QQrv1vVWDTKY=;
        b=K/2exEs7r3qJ/aBF7FrUjxMD4nPSssZTCcboGHpOUCIpqIVVVrLfJgz3YGXWvVmROR
         YoAXMsdqOlf7S+mwNqgLPCKD8xXvk9guqFmJSLWSn7HUQr/LBhO+R8pyySnIKjDBCKoP
         vw9EZ90VaTsOno4n1v2rCk9KnQW0HGE+zWGz3lywpBSaxH4Sx5fMwBNOm9m0sN17fjvd
         cs9lGUCgQXdojAhVllEem4+6GxRMqD7xAKd/pvPvjaytferrKBlJGBCwQFUsi5BMS7db
         heZZLH/gl8Glz9bxwJ0FzjoiJfS2AAzBWLpuwku3VTYal1BymC3lrj4Tnr0KnQQvXUc0
         CSPg==
X-Gm-Message-State: AOJu0YxOabj0sVspV7In4QePMIFwe7S2tUtXDz4smBohl1vpMERFdP/p
        PNMSXxugnd/6cKLjVACzJj5vQQ==
X-Google-Smtp-Source: AGHT+IGtL2iLYUJlhgmvNcyMOBZaZgk8LsHP+Lg3V1YoxUA98W1CImbL9WKhZVnyym4bCkI1REdtxQ==
X-Received: by 2002:a05:6214:517:b0:63c:e9dd:631e with SMTP id px23-20020a056214051700b0063ce9dd631emr3381973qvb.26.1691603089142;
        Wed, 09 Aug 2023 10:44:49 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id u15-20020a0cf1cf000000b0063d48fc1ae4sm4578389qvl.93.2023.08.09.10.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:44:48 -0700 (PDT)
Date:   Wed, 9 Aug 2023 13:44:48 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 8/8] fscrypt: make prepared keys record their type
Message-ID: <20230809174448.GG2516732@perftesting>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <64c47243cea5a8eca15538b51f88c0a6d53799cf.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64c47243cea5a8eca15538b51f88c0a6d53799cf.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:08PM -0400, Sweet Tea Dorminy wrote:
> Right now fscrypt_infos have two fields dedicated solely to recording
> what type of prepared key the info has: whether it solely owns the
> prepared key, or has borrowed it from a master key, or from a direct
> key.
> 
> The ci_direct_key field is only used for v1 direct key policies,
> recording the direct key that needs to have its refcount reduced when
> the crypt_info is freed. However, now that crypt_info->ci_enc_key is a
> pointer to the authoritative prepared key -- embedded in the direct key,
> in this case, we no longer need to keep a full pointer to the direct key
> -- we can use container_of() to go from the prepared key to its
> surrounding direct key.
> 
> The key ownership information doesn't change during the lifetime of a
> prepared key.  Since at worst there's a prepared key per info, and at
> best many infos share a single prepared key, it can be slightly more
> efficient to store this ownership info in the prepared key instead of in
> the fscrypt_info, especially since we can squash both fields down into
> a single enum.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
