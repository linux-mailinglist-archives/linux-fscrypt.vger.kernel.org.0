Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343B574BC24
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Jul 2023 07:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjGHFh6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 8 Jul 2023 01:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbjGHFhU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 8 Jul 2023 01:37:20 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA23268E
        for <linux-fscrypt@vger.kernel.org>; Fri,  7 Jul 2023 22:37:00 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3ff24a193dbso20893521cf.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 07 Jul 2023 22:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1688794619; x=1691386619;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tGA1GMuiBFLQbBC9Kx/aFBaGS7w0xHkPHFkJJNA2iSI=;
        b=H4OjjGgTuSgh0ERbXj1XvS/xTBxkB7UvM7Vfkrh52Yu8LpFcioo23H7LN2pCGL4LW1
         c0C5P5QmvB1fXe5I8JHSW7o4g1Ajl1MF/4+jjGWAydjxfqGvPpeQnueqoJppxuYX4Tib
         6hoyeiTFlWTndTuwvK6ZBpbmb3kDElpYHJNNeVJBjWMXxzLWOzeNN55RmVFRtgUieiJS
         n9eYbXhSBN+H4R2tcet2YEN9vvVt5VousOwqJlNxxiBZVJ8WFLL0sPVVImmpWJYvuSnT
         MhL7JtJsQDdw8I3gZFN5WtS2gjWSOchAsKTG4rNTzlHCYSShijuEZjZzESlquH/iq7kj
         ueNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688794619; x=1691386619;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tGA1GMuiBFLQbBC9Kx/aFBaGS7w0xHkPHFkJJNA2iSI=;
        b=V36mVsqGny7dQvHwy/SiWweS8E33d9W0AaBUbjY0wuQZRab5/6PfZgntzcxUnm/HKS
         4OFyhAAfJ6wGUR48soubuomE/XkQNeuWQZzrvCX1pPTzBSxEx4VPSSTiMOZlI4DTQaxV
         JLUOAGkO/8Sas4QJdyxY1niOZPrTSIODtMAV81QrelRItRq9ngLhSLyqrlyaUEHr9AEa
         ZkHauLFW8wsEhcoVEqSDdbKvFD628nFSgwnfPEcvt2YcwUr+PDfxEFcAzvAc9rGNWY9z
         a5QNiFdXqHLLS/toepa3XMSrbeRPEnL3SBmptD1XShVinbficwB4gBAhETHMY0gonUFI
         9D+A==
X-Gm-Message-State: ABy/qLY09amJtqzNOTSkyJyuNe66SHDjkOTJ2/iYWmS0GxFUnoxpsOWl
        9aWjdcuiTEoCFAE9gSW8R8UK
X-Google-Smtp-Source: APBJJlFF68xKBlrT8ZUzDF7hUpibBBTXCy89LqgKEgf14OWs8qrR4aAL2DMHEseMAEOpXtlRbrYnOQ==
X-Received: by 2002:ac8:7dc6:0:b0:3ff:2088:79d8 with SMTP id c6-20020ac87dc6000000b003ff208879d8mr9453816qte.4.1688794619449;
        Fri, 07 Jul 2023 22:36:59 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id a6-20020a0cca86000000b0062df126ca11sm2943696qvk.21.2023.07.07.22.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 22:36:59 -0700 (PDT)
Date:   Sat, 08 Jul 2023 01:36:58 -0400
Message-ID: <2edaa73fc9457f4a051115863d94b4ff.paul@paul-moore.com>
From:   Paul Moore <paul@paul-moore.com>
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 6/17] security: add new securityfs delete function
References: <1687986571-16823-7-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-7-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> When deleting a directory in the security file system, the existing
> securityfs_remove requires the directory to be empty, otherwise
> it will do nothing. This leads to a potential risk that the security
> file system might be in an unclean state when the intentded deletion
> did not happen.
> 
> This commit introduces a new function securityfs_recursive_remove
> to recursively delete a directory without leaving an unclean state.
> 
> Co-developed-by: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  include/linux/security.h |  1 +
>  security/inode.c         | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index e2734e9e44d5..a88076ebc7b1 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1971,6 +1971,7 @@ struct dentry *securityfs_create_symlink(const char *name,
>  					 const char *target,
>  					 const struct inode_operations *iops);
>  extern void securityfs_remove(struct dentry *dentry);
> +extern void securityfs_recursive_remove(struct dentry *dentry);
>  
>  #else /* CONFIG_SECURITYFS */
>  
> diff --git a/security/inode.c b/security/inode.c
> index 6c326939750d..13358e8547e8 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -313,6 +313,31 @@ void securityfs_remove(struct dentry *dentry)
>  }
>  EXPORT_SYMBOL_GPL(securityfs_remove);
>  
> +static void remove_one(struct dentry *victim)
> +{
> +	simple_release_fs(&mount, &mount_count);
> +}
> +
> +/**
> + * securityfs_recursive_remove - recursively removes a file or directory from the securityfs filesystem

I really want to see lines less than or equal to 80 characters; I
would suggest this:

"securityfs_recursive_remove - recursively removes a file or directory"

> + * @dentry: a pointer to a the dentry of the file or directory to be removed.
> + *
> + * This function recursively removes a file or directory in securityfs that was
> + * previously created with a call to another securityfs function (like
> + * securityfs_create_file() or variants thereof.)
> + */
> +void securityfs_recursive_remove(struct dentry *dentry)
> +{
> +	if (IS_ERR_OR_NULL(dentry))
> +		return;
> +
> +	simple_pin_fs(&fs_type, &mount, &mount_count);
> +	simple_recursive_removal(dentry, remove_one);
> +	simple_release_fs(&mount, &mount_count);
> +}
> +EXPORT_SYMBOL_GPL(securityfs_recursive_remove);
> +
>  #ifdef CONFIG_SECURITY
>  static struct dentry *lsm_dentry;
>  static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
> -- 
> 2.25.1

--
paul-moore.com
