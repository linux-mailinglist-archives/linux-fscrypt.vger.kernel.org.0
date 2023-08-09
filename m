Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76264776697
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 19:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjHIRkX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 13:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjHIRkW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 13:40:22 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DF210D8
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 10:40:22 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-3a78a2c0f81so41264b6e.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 10:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691602821; x=1692207621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d9Qgy/RFLkcndLrNg9NysYZRiW6/MTg0njN7CWo2D+o=;
        b=qzwlpeN6mc3ms6LAVdrBVWDc/ulq/6W8qYNrIkxsMck4treAPMm/J4vKHC1Qb973NH
         HaM5SUlppAC5Koz8DBySvp4SRJ9bEExq8Yfi8s3n2KSYGEuEdl0hNDD5dTjX/5nSDMnA
         6k4RIWvPV1v9qiThsTKuDqd9pmnDB5IdHaDZCiz4W0tHUI5Gu8VzErXUo5bGvxqa0IfZ
         lfEG01vDcUlUgefy7xBu0EgB7Cl3/jocVVFQu5kDq86nkIdrrSMdjstbLyXga1OKbX5h
         xWTtubfZgEya3HTZNuEPgqF+1Cv45BsoCMJuZfzJ9SRqvzigSADw0wl48a5dXpkvkdiR
         z5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691602821; x=1692207621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9Qgy/RFLkcndLrNg9NysYZRiW6/MTg0njN7CWo2D+o=;
        b=TwmqzE3eLQjR2dBjWEc+1UnmKKXf8FQagJ1tMFL9Y1yuQ5jp4UgWdTnf3l4dHEVmX6
         0qC4HdI1glX8a+GisXinxdq+f84fJO1WbFC5vEzAbhzneMEv+lpkXSGRbwDXfJVxDykj
         NH9kZO1hIDESbeem7Kzfs1pYffTpjQ9XqvkEtgdXeXXcb2mKEtbyEdXkRx4yfdb0fiEc
         LwyJWX9v00fj4x8/feRJyZlq8P77NhL4CE7LI7+M4YV/y+kofr7lexCSH2nndbRnU3tm
         4SiahxE7i7uI6wbp/79vu1Useativ6GGmQt/VixIjV2pMxUmClFcvcGERL2OrHKz/75X
         kctg==
X-Gm-Message-State: AOJu0YwzKJM8rh5axvOkZ18NHU8XvY/kjSQt7HPGIoRTPPRG+Gvy7dpZ
        EkU2hF/FvnFfjOENNDKrotoQDg==
X-Google-Smtp-Source: AGHT+IEr3ltZ8Drktp4wxRpNkn5n8GUGC0kpzdDRuUYLratEvAHZB67FKU35J/KLGgNPzLCC1kdCEg==
X-Received: by 2002:a05:6808:2095:b0:3a7:67bf:6488 with SMTP id s21-20020a056808209500b003a767bf6488mr12911oiw.19.1691602821457;
        Wed, 09 Aug 2023 10:40:21 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id p9-20020a0ccb89000000b006365b23b5dfsm4551332qvk.23.2023.08.09.10.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:40:20 -0700 (PDT)
Date:   Wed, 9 Aug 2023 13:40:19 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 6/8] fscrypt: move all the shared mode key setup deeper
Message-ID: <20230809174019.GE2516732@perftesting>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <953985195b4cce824ed64ee68827558544e93dcc.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <953985195b4cce824ed64ee68827558544e93dcc.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:06PM -0400, Sweet Tea Dorminy wrote:
> Currently, fscrypt_setup_v2_file_key() has a set of ifs which encode
> various information about how to set up a new mode key if necessary for
> a shared-key policy (DIRECT or IV_INO_LBLK_*). This is somewhat awkward
> -- this information is only needed at the point that we need to setup a
> new key, which is not the common case; the setup details are recorded as
> function parameters relatively far from where they're actually used; and
> at the point we use the parameters, we can derive the information
> equally well.
> 
> So this moves mode and policy checking as deep into the callstack as
> possible. mk_prepared_key_for_mode_policy() deals with the array lookup
> within a master key. And fill_hkdf_info_for mode_key() deals with
> filling in the hkdf info as necessary for a particular policy. These
> seem a little clearer in broad strokes, emphasizing the similarities
> between the policies, but it does spread out the information on how the
> key is derived for a particular policy more.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
