Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9055B2000
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 16:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiIHOCF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiIHOBq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 10:01:46 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98A2FF0B9
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 07:01:37 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id d15so472991qka.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 07:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=K5hy93Z6ga6TdX9NLs0OYROrPh3LbazWOcdJomNmR/I=;
        b=tj19onzdjQZ3OURbg3w8b/M1MQKb54XdoG0TgEAboyBQXLoiIz1SDxy4ba+3OWblJD
         9A38PQyx70X2mJB78WFsNGMgmVxysdzWxs6NXxKf/uC9aCUco82OuJKphXhSz8EgDtpd
         /feYSx8YMgMlqxluR3TpYXBXV7KOqpNqRFe/W/ypdn5B9q7jU4iFfXUXoqOUsjm+lFhu
         rNdTYi1uZ8ev5hVTZ/YOzsfyirhXRDGlTjWB+oTeohtoxjF7kGrg8h4AHQKnuVucGDAU
         Dc8FFBf/8T3FLpCbmhKBlGYMnD+jcWcIX7K3s7ce5QXfeTSXCmoZSlnYsZhRXEplakzM
         ecYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=K5hy93Z6ga6TdX9NLs0OYROrPh3LbazWOcdJomNmR/I=;
        b=BS5dnEYPKVSKq5VpW9dkFsiPrN4EhEYVFLyaDSTneaNijNxNRgHwiGa1x5NiqSquhV
         IM655TmfbxXRXwdcZQgiqqUFl1YhA/5IX62UKhv3Jukcuj4h4CS7EREiBbjyeG4mb+Qq
         7dl2FeZzyJt5d5xSYM3wcxI1z1xzk+HtRicjhQzhDX0EdltFONu0qVPHdXXPwuVQfU7V
         n+VhLT+Q53oQhB1x8d5b3o+7peZDS5iO5t0fTz6ET4hZLcuZ+J/smXbLcLVTG5BbY0b6
         cwuuK5JTViU3fKGViX1IF4MRk+ZY5QQvG3p2rVx7xwcuzb+Nh2FJsxKhvdOBBnbLos4M
         7y9A==
X-Gm-Message-State: ACgBeo0VgAMjyVQuPseVdJ+QheMPuMmDIZDwqjvBXk2gOo8uKa83/esa
        QuAnW4raOLNLB8M0LHm1Giv0syBfH9yH5w==
X-Google-Smtp-Source: AA6agR78fUV9opopBJ/g2NQuu2zLZz/S0bP7UOHlRwcUBoIyzDZ5XH/zeNfGrr6GUUONB3ALzjUNVg==
X-Received: by 2002:a05:620a:1a23:b0:6bc:3aa1:510b with SMTP id bk35-20020a05620a1a2300b006bc3aa1510bmr6611970qkb.229.1662645696780;
        Thu, 08 Sep 2022 07:01:36 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id g16-20020a05620a40d000b006b93b61bc74sm17685663qko.9.2022.09.08.07.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:01:35 -0700 (PDT)
Date:   Thu, 8 Sep 2022 10:01:34 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 04/20] fscrypt: allow fscrypt_generate_iv() to
 distinguish filenames
Message-ID: <Yxn1vis5cE/5SMNl@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <bc34486c30d3d0bfd5404358f7bd566d802748be.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc34486c30d3d0bfd5404358f7bd566d802748be.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:19PM -0400, Sweet Tea Dorminy wrote:
> With the introduction of extent-based file content encryption, filenames
> and file contents might no longer use the same IV generation scheme, and
> so should not upass the same logical block number to
> fscrypt_generate_iv(). In preparation, start passing U64_MAX as the
> block number for filename IV generation, and make fscrypt_generate_iv()
> translate this to 0 if extent-based encryption is not being used.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

I had to go look at how you used this, because it seemed superflous to me, but
it's because later you put the IV generation stuff above this particular bit of
code.  You say that we set it to 0 if extent-based encryption is not being used,
but looking at this in vimdiff I don't know where that's going to be.  So
perhaps something like

I will be adding code to generate IV's for extent-based encryption before
falling through to the other policy types, and I will check for U64_MAX to skip
the extent-based generation.  At this point we'll want to switch back to 0 for
filenames.

Or some other such description.  Thanks,

Josef
