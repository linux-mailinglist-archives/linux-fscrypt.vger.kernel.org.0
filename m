Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F308B66307E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Jan 2023 20:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbjAITfm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Jan 2023 14:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbjAITfj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Jan 2023 14:35:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AF01649A
        for <linux-fscrypt@vger.kernel.org>; Mon,  9 Jan 2023 11:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673292891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQMDnAlZYFrg+FDGtR42bVuM/yGIczuxLJaq+U0aLyM=;
        b=EexZ35QrUi+QM1auwV0h+B8NAbPZeyAHWuu3XK9ScotrLysaPKzcebe0TwAbiuo+e5E03T
        PKvt4NdOfOESSVuZxkQLzChxPtMcKnhQasWt/5UxYCCGhaht8rEEvNE9I1LY2asd8YLgFj
        Qjn/Sj+1UWsNsnCwaBKf6T5PamUSw9M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-563-7k1_wfJNN2y9drYGud9xDA-1; Mon, 09 Jan 2023 14:34:50 -0500
X-MC-Unique: 7k1_wfJNN2y9drYGud9xDA-1
Received: by mail-ed1-f70.google.com with SMTP id w3-20020a056402268300b00487e0d9b53fso5959442edd.10
        for <linux-fscrypt@vger.kernel.org>; Mon, 09 Jan 2023 11:34:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQMDnAlZYFrg+FDGtR42bVuM/yGIczuxLJaq+U0aLyM=;
        b=RsF6ijVGPyxWPXDDOTztXqjQ4+H2hjekixkhGmJD2zRGK6miC9dHyY6DY1rrAr5CRK
         uwv9gIBBIfovbxzk1V+eDzjhgtJz9fOiHRO5oCkiTIfiHdj0BmZehCrjiFVYrdnDWNH0
         TSXk//ox1xj5h4QG7mKp6QD/t6SfuYCKx45MM2f7K+PABRQEnitc+g9LDpVbmhfFgvcx
         IxDRWPPM1aSv6crKCNTt+CmQiwHC3vjw86mg59LVrMcAs19wc+JVYXsbqANdOFXRxlsp
         O41qfulub5QQLfyaMFC2Tht1M94eNuV74h6RNgCSwl+1LbFQE6+dtKU9azckB8MgbZpB
         Txkg==
X-Gm-Message-State: AFqh2koYncBFh5bYFHlVVHUdMv0HBHXlm4etoXrbWTUYIPMFatdlVUgZ
        qnvEWLWGZZTFX/TViBOfxmU+OZbdsgDUdRppVHikxHkxtlnhWB/LwD5vCg3vDCJjsJF/SFNa16O
        0LeZbJ3BvAUw2CU1GwV4hbn2p
X-Received: by 2002:a17:907:1759:b0:7ad:d250:b903 with SMTP id lf25-20020a170907175900b007add250b903mr72215586ejc.56.1673292889358;
        Mon, 09 Jan 2023 11:34:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu21stgD+/1EjhJf7J1BgUsBezxrJQMbjX6bK3yWH2CTzDuxtPuKAfnC7i/jdXetHE5M2jNRw==
X-Received: by 2002:a17:907:1759:b0:7ad:d250:b903 with SMTP id lf25-20020a170907175900b007add250b903mr72215575ejc.56.1673292889177;
        Mon, 09 Jan 2023 11:34:49 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709061da200b0083f91a32131sm4076001ejh.0.2023.01.09.11.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 11:34:48 -0800 (PST)
Date:   Mon, 9 Jan 2023 20:34:46 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] fsverity: support for non-4K pages
Message-ID: <20230109193446.mpmbodoctaddovpv@aalbersh.remote.csb>
References: <20221223203638.41293-1-ebiggers@kernel.org>
 <Y7xRIZfla92yzK9N@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7xRIZfla92yzK9N@sol.localdomain>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,SUSPICIOUS_RECIPS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 09, 2023 at 09:38:41AM -0800, Eric Biggers wrote:
> On Fri, Dec 23, 2022 at 12:36:27PM -0800, Eric Biggers wrote:
> > [This patchset applies to mainline + some fsverity cleanups I sent out
> >  recently.  You can get everything from tag "fsverity-non4k-v2" of
> >  https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git ]
> 
> I've applied this patchset for 6.3, but I'd still greatly appreciate reviews and
> acks, especially on the last 4 patches, which touch files outside fs/verity/.
> 
> (I applied it to
> https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=fsverity for now,
> but there might be a new git repo soon, as is being discussed elsewhere.)
> 
> - Eric
> 

The fs/verity patches look good to me, I've checked them but forgot
to send RVB :( Haven't tested them yet though

Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

