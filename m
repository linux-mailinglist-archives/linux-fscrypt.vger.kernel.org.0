Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079C22E2668
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Dec 2020 12:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgLXLcZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Dec 2020 06:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgLXLcY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Dec 2020 06:32:24 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B22C061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 24 Dec 2020 03:31:44 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id q22so1099744pfk.12
        for <linux-fscrypt@vger.kernel.org>; Thu, 24 Dec 2020 03:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zXY42oT/IW9W4tJIWg8idExqObCy32gAmaijR4rjF1k=;
        b=tasYL7NDdsgjOvHsXfKiTg6RsX2VVEUiR660KdKbDAJ+anhfmdQGDkX9vzI9qE2Wfg
         D6CeLXOpsNtajFrjEg2Kvpdfgsj7zQdVdmTG+jUtqGd1+Pp7+QThscCz2HLI9mMqJ3o2
         dnMwIAO73+R0XDxY+xKffYS0w3tw3bIFYQrGL8FZHuQ/ec4dfPahw74XJT0/o6xJnbFI
         W39UfHSs6lFt0bVZ9+nlZnKy5u4ydbzCc+9Exuht45c/sHxUwOjaF0RNGSku1CalxHou
         nVCyE/e2FwtffzyOZCkBq3UznvsQhtbMLxlGeksuI4rpaLVzY6atQdcL0/e9UKOAIOoX
         B8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zXY42oT/IW9W4tJIWg8idExqObCy32gAmaijR4rjF1k=;
        b=ZsoEHv2irjwZgoUk2YR0uCDUqFEKgGJOIuoBhTVTPdoTj2oMW9j3SXfRkWBxxJpJLi
         kEKK7o0VpZqJTcjHoLDiRL1MdG1jY64MxKtkfZdaRT1CbZaA1r+1qW6YTf38Hfbx3PUN
         vj+qPWqWqQ0vj3MB9Z0fVZIq8vy2BA0tbjs0PuUvyy/bce9rieYerD6AePsJf6h7suOy
         VdeM3LpffRW4Qnb1urTgn1yBxUKOn2McJHqnfrhN7curhtQD7d//I3T6A79FJqmypqE3
         NEzB+MpjwCYurZhtFymL7GnpvpuNJs3rXbWdP+yztGuhJuvG3SK5EmXkgZYdljg37+BX
         CVtA==
X-Gm-Message-State: AOAM532zsL8hxZtGfN8dGnXYNX74FGU2Dh4MYFj4bq6ruhslzvfHptwJ
        i0w0Nvue9AalvdqX7xHOhExQ4g==
X-Google-Smtp-Source: ABdhPJzGhpTmNmlaMaxMdc175O0Y77lm3F7udCcKdqjz0RRMYX0sonEKFyMyDx9SO3y79wBhWWcHgA==
X-Received: by 2002:a65:494f:: with SMTP id q15mr28291332pgs.367.1608809503493;
        Thu, 24 Dec 2020 03:31:43 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id x125sm13594315pgb.35.2020.12.24.03.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 03:31:42 -0800 (PST)
Date:   Thu, 24 Dec 2020 11:31:39 +0000
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 2/3] fscrypt: Add metadata encryption support
Message-ID: <X+R8G5/Htwau2b34@google.com>
References: <20201217150435.1505269-1-satyat@google.com>
 <20201217150435.1505269-3-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217150435.1505269-3-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

I realized I didn't update fscrypt_mergeable_bio() to take metadata
encryption into account, so bios will be more fragmented than required.
I'll fix it in v3.
