Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422185164BB
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 16:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347642AbiEAObf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 10:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347636AbiEAObe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 10:31:34 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1A320188
        for <linux-fscrypt@vger.kernel.org>; Sun,  1 May 2022 07:28:08 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id e17so8828462qvj.11
        for <linux-fscrypt@vger.kernel.org>; Sun, 01 May 2022 07:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d7QK1GW7lP1qbCKVFdvjJcmsoTKCx8yr/Y/NGlYiKTM=;
        b=adi/Q4rjKqdJ5NyijvTh1FJ32lctyt9gegxOKlUti0QGPejTQABqCgz44IhGhe66Fz
         9nmXtaQuovlthu7nO534E3gHVljWv4PqzjD3BbK5VUA0o6nzd/uzg+lIYFzXOb54whg3
         kIbVQKuq4z90kptZ3Nrta3L78pw8s4nqCBEAbczZ0caWe3s3F6OYSOaH2/hi4mnE9ic+
         1FRUiboQS8E1CH+uF3lKsZg0eKvBZAa/evxhcv5wIMzhUWcRfNeclGn85MQnq867GtM6
         dK8fjPu6Q5OQQFJqi9tJz5O0/wdxXKJqnduZ5VZsRt0tNQg5eJPoxRGilZ8rkS+roWlW
         VMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d7QK1GW7lP1qbCKVFdvjJcmsoTKCx8yr/Y/NGlYiKTM=;
        b=By1Bh7N2g6fAo0VbK1d2IbkaZpvF5U/4bOTD/DJB2mDY0pk7YITX8bIId1oNsiB5/y
         I4mnsgnGUP3wQzTwtkYQhS8oEMHfVIvH6l9rjDzIvqThKMsQH3lI5Y7CUvTXLQQk5Ijz
         QzujIr/F5zmUJmV2rq3TKWpmkHxx1hhWB6AfgnhHbLOh6WCu5SiIBEktUvwcTvYD6M0g
         XLtdjWyCEG+3mtJCwTKwx0KLFTOUWP72kjGwVjKOxeU+41tFwZJo6gJFRrvtSt+uY+Oo
         djhEkFAIVkHZmWNih0IfK/tL/CwaVN1VTQ5t4JUbNKh3VlvbA5KJ7CAQhAiOPkWTyghO
         gwdw==
X-Gm-Message-State: AOAM530Rotda9ssWqPcXDYCKFJrTAD7TpKyuhWm10wrunFYlgrjnNMcr
        PRQ57SjBwuj7deZT53M2WPAs0Q==
X-Google-Smtp-Source: ABdhPJxGzSX6uTX86FySckLDq4xHvc4dBX/esxM/eMsLRFoUMsoS1L2OIYV+7fjmcg9SgJajescjMQ==
X-Received: by 2002:a05:6214:5282:b0:443:e161:ef4a with SMTP id kj2-20020a056214528200b00443e161ef4amr6311029qvb.23.1651415287932;
        Sun, 01 May 2022 07:28:07 -0700 (PDT)
Received: from localhost ([173.95.209.66])
        by smtp.gmail.com with ESMTPSA id d26-20020ac847da000000b002f39b99f66esm2762722qtr.8.2022.05.01.07.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 07:28:07 -0700 (PDT)
Date:   Sun, 1 May 2022 10:28:06 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v9 1/5] common/verity: require corruption functionality
Message-ID: <Ym6Y9pMybZcSeHTm@localhost.localdomain>
References: <cover.1651012461.git.boris@bur.io>
 <657cd5facdbd0b41ee99ab18ad0bba9f0d690729.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <657cd5facdbd0b41ee99ab18ad0bba9f0d690729.1651012461.git.boris@bur.io>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 26, 2022 at 03:40:12PM -0700, Boris Burkov wrote:
> Corrupting ext4 and f2fs relies on xfs_io fiemap. Btrfs corruption
> testing will rely on a btrfs specific corruption utility. Add the
> ability to require corruption functionality to make this properly
> modular. To start, just check for fiemap, as that is needed
> universally for _fsv_scratch_corrupt_bytes.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
